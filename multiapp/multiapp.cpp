#include "multiapp.hpp"

ACTION multiapp::addproposal (const name proposer,
                                const string proposal_name,
                                const string proposal_text,
                                const string supplemental_uri,
                                const string approval_timeframe)
{
    require_auth (proposer);

    proposal_table p_t (get_self(), get_self().value);
    p_t.emplace (get_self(), [&](auto &p) {
        p.proposal_id = p_t.available_primary_key();
        p.proposer = proposer;
        p.proposal_name = proposal_name;
        p.proposal_text = proposal_text;
        p.supplemental_uri = supplemental_uri;
        
        if (approval_timeframe.compare(ONE_DAY)) {
          p.approval_deadline = now() + ONE_DAY_SECONDS;
        } else if (approval_timeframe.compare(THREE_DAYS)) {
          p.approval_deadline = now() + THREE_DAYS_SECONDS;
        } else if (approval_timeframe.compare(ONE_WEEK)) {
          p.approval_deadline = now() + ONE_WEEK_SECONDS;
        } else if (approval_timeframe.compare(TWO_WEEKS)) {
          p.approval_deadline = now() + TWO_WEEKS_SECONDS;
        } else if (approval_timeframe.compare(THIRTY_DAYS)) {
          p.approval_deadline = now() + THIRTY_DAYS_SECONDS;
        } else {
          p.approval_deadline = now();  // for info; does not enforce anything
        }

        p.status = PROP_STATUS_OPEN;
        p.created_date = now();
    });
}

ACTION multiapp::addapprover (const uint64_t  proposal_id, 
                              const uint16_t  approval_sequence,
                              const name      required_approver)
{
    proposal_table p_t (get_self(), get_self().value);
    auto p_itr = p_t.find (proposal_id);
    eosio_assert (p_itr != p_t.end(), "Proposal ID is not found.");

    require_auth (p_itr->proposer);

    approval_table a_t (get_self(), get_self().value);
    auto proposal_index = a_t.get_index<"byproposal"_n>();
    auto a_itr = proposal_index.find (proposal_id);
    while (a_itr->proposal_id == proposal_id && a_itr != proposal_index.end()) {
      if (a_itr->required_approver == required_approver) {
        eosio_assert (a_itr->approval_sequence != approval_sequence, "Approver and sequence already created for this proposal.");
      }
      a_itr++;
    }

    a_t.emplace (get_self(), [&](auto &a) {
      a.approval_id = a_t.available_primary_key();
      a.proposal_id = proposal_id;
      a.approval_sequence = approval_sequence;
      a.required_approver = required_approver;
      a.approval_status = APP_STATUS_UNAPPROVED;
    });

}

ACTION multiapp::delproposal (const uint64_t proposal_id)
{
    proposal_table p_t (get_self(), get_self().value);
    auto p_itr = p_t.find (proposal_id);
    eosio_assert (p_itr != p_t.end(), "Proposal ID is not found.");

    eosio_assert (  has_auth (get_self()) || 
                    has_auth(p_itr->proposer), "Permission to delete proposal denied.");

    approval_table a_t (get_self(), get_self().value);
    auto proposal_index = a_t.get_index<"byproposal"_n>();
    auto a_itr = proposal_index.find (proposal_id);
    while (a_itr->proposal_id == proposal_id && a_itr != proposal_index.end()) {
      a_itr = proposal_index.erase (a_itr);
    }

    p_t.erase (p_itr);
}

ACTION multiapp::approve(const name approver, const uint64_t approval_id) 
{
    approval_table a_t (get_self(), get_self().value);
    auto a_itr = a_t.find (approval_id);
    eosio_assert (a_itr != a_t.end(), "Approval ID is not found.");
    eosio_assert (a_itr->required_approver == approver, "Approver does not match required approver.");

    bool approval_remaining = false;

    auto proposal_index = a_t.get_index<"byproposal"_n>();
    auto a_prop_itr = proposal_index.find (a_itr->proposal_id);

    while (a_itr->proposal_id == a_prop_itr->proposal_id && a_prop_itr != proposal_index.end()) {
      // print (" Approval ID: ", a_prop_itr->approval_id, "\n");
      // print (" Approval Status: ", a_prop_itr->approval_status, "\n");
      if (a_prop_itr->approval_status.compare (APP_STATUS_UNAPPROVED) == 0 && 
        a_prop_itr->approval_id != approval_id) {
        
        // print (" Setting approval_remaining to true\n\n");
        approval_remaining = true;
        eosio_assert (a_prop_itr->approval_sequence >= a_itr->approval_sequence, "Other approvals must be executed before this one.");
      }
      a_prop_itr++;
    }

    a_t.modify (a_itr, get_self(), [&](auto &a) {
      a.approval_status = APP_STATUS_APPROVED;
      a.approval_date = now();
    });

    proposal_table p_t (get_self(), get_self().value);
    auto p_itr = p_t.find (a_itr->proposal_id);
    eosio_assert (p_itr != p_t.end(), "Proposal ID is not found.");

    // print (" Approval remaining: ", approval_remaining, "\n");
    // print (" Proposal status: ", p_itr->status, "\n");

    // action (
    //   permission_level{approver, "active"_n},
    //   "eosio.msig"_n, "approve"_n,
    //   std::make_tuple(p_itr->proposer, p_itr->proposal_name))
    // .send();

    p_t.modify (p_itr, get_self(), [&](auto &p) {
      if (approval_remaining) {
        p.status = PROP_STATUS_PARTIALLY_APPROVED;
      } else {
        p.status = PROP_STATUS_FULLY_APPROVED;
        p.last_user_approval_date = now();

        // action (
        //   permission_level{get_self(), "active"_n},
        //   "eosio.msig"_n, "exec"_n,
        //   std::make_tuple(p_itr->proposer, p_itr->proposal_name, get_self()))
        // .send();
        // print (" Executing action with full approval");
      }
    });
}

EOSIO_DISPATCH(multiapp, (addproposal)(addapprover)(approve)(delproposal))