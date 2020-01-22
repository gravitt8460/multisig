
#include <eosiolib/asset.hpp>
#include <eosiolib/eosio.hpp>
#include <eosiolib/singleton.hpp>
#include <string>

using std::string;
using namespace eosio;

CONTRACT multiapp : public contract
{
    using contract::contract;

  public:

    ACTION addproposal (const name    proposer,
                        const string  proposal_name,
                        const string  proposal_text,
                        const string  supplemental_uri,
                        const string  approval_timeframe);

    ACTION addapprover (const uint64_t  proposal_id, 
                        const uint16_t  approval_sequence,
                        const name      required_approver);

    ACTION approve (const name approver, const uint64_t approval_id);

    ACTION delproposal (const uint64_t proposal_id);
    
  private:

    const string PROP_STATUS_OPEN = "Open - Unapproved";
    const string PROP_STATUS_PARTIALLY_APPROVED = "Partially Approved";
    const string PROP_STATUS_FULLY_APPROVED = "Fully Approved";

    const string APP_STATUS_UNAPPROVED = "Unapproved";
    const string APP_STATUS_APPROVED= "Approved";

    // valid time frames
    const string ONE_DAY = "1 DAY";
    const string THREE_DAYS = "3 DAYS";
    const string ONE_WEEK = "1 WEEK";
    const string TWO_WEEKS = "2 WEEKS";
    const string THIRTY_DAYS = "30 DAYS";

    const uint32_t  ONE_DAY_SECONDS = 60 * 60 * 24;
    const uint32_t  THREE_DAYS_SECONDS = ONE_DAY_SECONDS * 3;
    const uint32_t  ONE_WEEK_SECONDS = ONE_DAY_SECONDS * 7;
    const uint32_t  TWO_WEEKS_SECONDS = ONE_DAY_SECONDS * 14;
    const uint32_t  THIRTY_DAYS_SECONDS = ONE_DAY_SECONDS * 30;

    // TABLE Config
    // {
    //     asset       gft_eos_rate;
    //     float       gyfter_payback_rate;      
    // };

    // typedef singleton<"configs"_n, Config> config_table;
    // typedef eosio::multi_index<"configs"_n, Config> config_table_placeholder;
    
    TABLE proposal
    {
        uint64_t    proposal_id;
        name        proposer;
        string      proposal_name;
        string      proposal_text;
        string      supplemental_uri;
        string      status;
        uint32_t    created_date;
        uint32_t    approval_deadline;
        uint32_t    last_user_approval_date;  
        //uint32_t    last_modified_date;      
        uint64_t    primary_key() const { return proposal_id; }
        uint64_t    by_proposer() const { return proposer.value; }
    };

    typedef eosio::multi_index<"proposals"_n, proposal,
      indexed_by<"byproposer"_n,
        const_mem_fun<proposal, uint64_t, &proposal::by_proposer>>
    > proposal_table;

    TABLE approval 
    {
      uint64_t  approval_id;
      uint64_t  proposal_id;
      uint16_t  approval_sequence;
      name      required_approver;
      string    approval_status;
      uint32_t  approval_date;
      uint64_t  primary_key() const { return approval_id; }
      uint64_t  by_approver() const { return required_approver.value; }
      uint64_t  by_proposal() const { return proposal_id; }
    };

    typedef eosio::multi_index<"approvals"_n, approval,
      indexed_by<"byapprover"_n,
        const_mem_fun<approval, uint64_t, &approval::by_approver>>,
      indexed_by<"byproposal"_n,
        const_mem_fun<approval, uint64_t, &approval::by_proposal>>
    > approval_table;

};
