
cleos create account eosio token EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj
cleos create account eosio signature1 EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj
cleos create account eosio signature2 EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj
cleos create account eosio signature3 EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj EOS85AboyypCNfuENiDo8986J3tGiXMQ46m1eTimB1GDzKvVHNqWj

cleos set contract token token/

------

bitcarbonpa1, bitcarbonpa2, bitcarbonpa3

cleos -u https://jungle2.cryptolions.io:443 push action bitcarbontok create '["bcdetreasury", "1000000000.0000 BCDE"]' -p bitcarbontok

cleos -u https://jungle2.cryptolions.io:443 push action bitcarbontok issue '["bcdetreasury", "1000000000.0000 BCDE", "issue all tokens to treasury"]' -p bcdetreasury

cleos -u https://jungle2.cryptolions.io:443 set account permission bcdetreasury active '{"threshold":2,"keys":[],"accounts":[{"permission":{"actor":"bitcarbonpa1","permission":"active"},"weight":1},{"permission":{"actor":"bitcarbonpa2","permission":"active"},"weight":1},{"permission":{"actor":"bitcarbonpa3","permission":"active"},"weight":1}],"waits":[]}' owner -p bcdetreasury@owner

------

# propose a multisig transaction
cleos -u https://jungle2.cryptolions.io:443 multisig propose sendtorec4 '[{"actor": "bitcarbonpa1", "permission": "active"}, {"actor": "bitcarbonpa2", "permission": "active"}, {"actor": "bitcarbonpa3", "permission": "active"}]' '[{"actor": "bcdetreasury", "permission": "active"}]'  bitcarbontok transfer '{"from":"bcdetreasury", "to":"bitreceiver1", "quantity":"25.0000 BCDE", "memo":"Multisig Test"}' -p bitcarbonpa1@active

# view the transaction proposal
cleos -u https://jungle2.cryptolions.io:443 multisig review bitcarbonpa1 sendtorec1

cleos -u https://jungle2.cryptolions.io:443 multisig approve bitcarbonpa1 sendtorec2 '{"actor": "bitcarbonpa1", "permission": "active"}' -p bitcarbonpa1

cleos -u https://jungle2.cryptolions.io:443 multisig approve bitcarbonpa1 sendtorec2 '{"actor": "bitcarbonpa2", "permission": "active"}' -p bitcarbonpa2

cleos -u https://jungle2.cryptolions.io:443 multisig approve bitcarbonpa1 sendtorec2 '{"actor": "bitcarbonpa3", "permission": "active"}' -p bitcarbonpa3

# execute approved multisig transaction - anyone can execute after it is fully approved
cleos -u https://jungle2.cryptolions.io:443 multisig exec bitcarbonpa1 sendtorec2 -p bitcabuser11




######

cleos -u https://jungle2.cryptolions.io:443 push action bitcarbontok create '["bitcarbontok", "1000000000.0000 EOS"]' -p bitcarbontok
cleos -u https://jungle2.cryptolions.io:443 push action bitcarbontok create '["bitcarbontok", "1000000000.00000000 GFT"]' -p bitcarbontok
cleos -u https://jungle2.cryptolions.io:443 push action bitcarbontok issue '["bitcarbontok", "100.0000 EOS", "memo"]' -p bitcarbontok
cleos -u https://jungle2.cryptolions.io:443 push action bitcarbontok issue '["bitcarbontok", "100.00000000 GFT", "memo"]' -p bitcarbontok
cleos -u https://jungle2.cryptolions.io:443 push action bitcarbontok transfer '["bitcarbontok", "gftorderbook", "100.0000 EOS", "memo"]' -p bitcarbontok
cleos -u https://jungle2.cryptolions.io:443 push action bitcarbontok transfer '["bitcarbontok", "gftorderbook", "100.00000000 GFT", "memo"]' -p bitcarbontok



cleos -u https://jungle2.cryptolions.io:443 set account permission gygenesisge1 owner '{"threshold":1,"keys":[],"accounts":[{"permission":{"actor":"gygenesisge1","permission":"eosio.code"},"weight":1}],"waits":[]}'  -p gygenesisge1@owner

cleos -u https://jungle2.cryptolions.io:443 set account permission gygenesisge1 active '{"threshold":2,"keys":[],"accounts":[{"permission":{"actor":"bitcarbonpa1","permission":"active"},"weight":1},{"permission":{"actor":"bitcarbonpa2","permission":"active"},"weight":1}],"waits":[]}' owner -p gygenesisge1@owner
