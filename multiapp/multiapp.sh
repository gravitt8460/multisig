
cleos create account eosio multiapp EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj
cleos create account eosio proposer EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj

cleos create account eosio approver1 EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj
cleos create account eosio approver2 EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj
cleos create account eosio approver3 EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj
cleos create account eosio approver4 EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj
cleos create account eosio approver5 EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj

cleos set contract multiapp multiapp/

cleos push action eosio updateauth '{"account":"multiapp","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"multiapp","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p multiapp

cleos push action multiapp addproposal '["proposer", "test1", "This is a test proposal", "link goes here", "1 DAY"]' -p proposer
cleos push action multiapp addapprover '[0, 1, "approver1"]' -p proposer
cleos push action multiapp addapprover '[0, 2, "approver2"]' -p proposer

cleos push action multiapp approve '["approver1", 0]' -p approver1
cleos push action multiapp approve '["approver2", 1]' -p approver2

cleos get table multiapp multiapp proposals
cleos get table multiapp multiapp approvals