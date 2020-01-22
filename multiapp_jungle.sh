
Private key: 5JtVyPa7edt7Q27m7XXMgQyF7ym4xATybLe6Yv9AyHWagpfntHS
Public key: EOS5VfJ7csH1vBM1mwi9znbg5uZXUjEWTExftnin1bV4JtnSEhf2i

multisigapp1
multisigprop
multisigsig1
multisigsig2
multisigsig3
multisigperm

cleos -u https://jungle2.cryptolions.io set contract multisigapp1 multiapp/
cleos -u https://jungle2.cryptolions.io push action multisigapp1 delproposal '[0]' -p multisigapp1
cleos -u https://jungle2.cryptolions.io push action multisigapp1 delproposal '[1]' -p multisigapp1
cleos -u https://jungle2.cryptolions.io push action multisigapp1 delproposal '[2]' -p multisigapp1
cleos -u https://jungle2.cryptolions.io push action multisigapp1 delproposal '[3]' -p multisigapp1




cleos -u https://jungle2.cryptolions.io push action eosio updateauth '{"account":"multisigapp1","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS5VfJ7csH1vBM1mwi9znbg5uZXUjEWTExftnin1bV4JtnSEhf2i", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"multisigapp1","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p multisigapp1

cleos -u https://jungle2.cryptolions.io push action multisigapp1 addproposal '["multisigprop", "test1", "This is a test proposal", "link goes here", "1 DAY"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[0, 1, "multisigsig1"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[0, 1, "multisigsig2"]' -p multisigprop

cleos -u https://jungle2.cryptolions.io push action multisigapp1 addproposal '["multisigprop", "test2", "This is a test proposal", "link goes here", "1 DAY"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[1, 1, "multisigsig1"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[1, 2, "multisigsig2"]' -p multisigprop

cleos -u https://jungle2.cryptolions.io push action multisigapp1 addproposal '["multisigprop", "test3", "This is a test proposal", "link goes here", "1 DAY"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[2, 1, "multisigsig1"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[2, 2, "multisigsig2"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[2, 3, "multisigsig3"]' -p multisigprop

cleos -u https://jungle2.cryptolions.io push action multisigapp1 addproposal '["multisigprop", "testxfer", "This is a proposal to send 1.1 TLOS", "https://mon-test.telosfoundation.io/account/multisigapp1", "1 DAY"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[3, 1, "multisigsig1"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[3, 2, "multisigsig2"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[3, 3, "multisigsig3"]' -p multisigprop


cleos -u https://jungle2.cryptolions.io set account permission multisigperm active '{"threshold":2,"keys":[],"accounts":[{"permission":{"actor":"multisigsig1","permission":"active"},"weight":1},{"permission":{"actor":"multisigsig2","permission":"active"},"weight":1},{"permission":{"actor":"multisigsig3","permission":"active"},"weight":1}],"waits":[]}' owner -p multisigperm@owner
cleos -u https://jungle2.cryptolions.io set account permission multisigperm owner '{"threshold":2,"keys":[],"accounts":[{"permission":{"actor":"multisigsig1","permission":"active"},"weight":1},{"permission":{"actor":"multisigsig2","permission":"active"},"weight":1},{"permission":{"actor":"multisigsig3","permission":"active"},"weight":1}],"waits":[]}'  -p multisigperm@owner


###########
cleos -u https://jungle2.cryptolions.io push action -sjd -x 86400 eosio.token transfer '["multisigperm","multisigsig1","10.1000 EOS","multisig test"]' -p multisigperm > trx.json
cleos -u https://jungle2.cryptolions.io multisig propose_trx testxfer '[{"actor": "multisigsig1", "permission": "active"}, {"actor": "multisigsig2", "permission": "active"}, {"actor": "multisigsig3", "permission": "active"}]' ./trx.json -p multisigprop

cleos -u https://jungle2.cryptolions.io multisig review multisigprop testxfer
cleos -u https://jungle2.cryptolions.io multisig approve multisigprop testxfer '{"actor": "multisigsig1", "permission": "active"}' -p multisigsig1
cleos -u https://jungle2.cryptolions.io multisig approve multisigprop testxfer '{"actor": "multisigsig2", "permission": "active"}' -p multisigsig2
cleos -u https://jungle2.cryptolions.io multisig exec multisigprop testxfer -p multisigsig1

cleos -u https://jungle2.cryptolions.io multisig cancel multisigprop testxfer -p multisigprop

cleos -u https://jungle2.cryptolions.io multisig approve multisigprop testxfer -p multisigsig3


######################


cleos -u https://jungle2.cryptolions.io push action -sjd -x 86400 eosio.token transfer '["multisigperm","multisigsig1","10.0000 EOS","multisig test"]' -p multisigperm > trx.json
cleos -u https://jungle2.cryptolions.io multisig propose_trx testxfer '[{"actor": "multisigsig1", "permission": "active"}, {"actor": "multisigsig2", "permission": "active"}, {"actor": "multisigsig3", "permission": "active"}]' ./trx.json -p multisigprop

cleos -u https://jungle2.cryptolions.io push action multisigapp1 addproposal '["multisigprop", "testxfer", "A test transfer of 10.0000 EOS.", "https://jungle.bloks.io/account/multisigsig1", "1 DAY"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[1, 1, "multisigsig1"]' -p multisigprop
cleos -u https://jungle2.cryptolions.io push action multisigapp1 addapprover '[1, 2, "multisigsig2"]' -p multisigprop

#######################

 cleos -u http://testnet.telos.eossweden.eu set contract multisigapp1 multiapp/
 cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 delproposal '[0]' -p multisigapp1

# cleos -u http://testnet.telos.eossweden.eu push action eosio updateauth '{"account":"multisigapp1","permission":"active","parent":"owner","auth":{"keys":[{"key":"EOS5VfJ7csH1vBM1mwi9znbg5uZXUjEWTExftnin1bV4JtnSEhf2i", "weight":1}],"threshold":1,"accounts":[{"permission":{"actor":"multisigapp1","permission":"eosio.code"},"weight":1}],"waits":[]}}' -p multisigapp1

# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addproposal '["multisigprop", "test1", "This is a test proposal", "link goes here", "1 DAY"]' -p multisigprop
# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[0, 1, "multisigsig1"]' -p multisigprop
# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[0, 1, "multisigsig2"]' -p multisigprop

# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addproposal '["multisigprop", "test2", "This is a test proposal", "link goes here", "1 DAY"]' -p multisigprop
# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[1, 1, "multisigsig1"]' -p multisigprop
# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[1, 2, "multisigsig2"]' -p multisigprop

# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addproposal '["multisigprop", "test3", "This is a test proposal", "link goes here", "1 DAY"]' -p multisigprop
# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[2, 1, "multisigsig1"]' -p multisigprop
# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[2, 2, "multisigsig2"]' -p multisigprop
# cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[2, 3, "multisigsig3"]' -p multisigprop


# cleos -u http://testnet.telos.eossweden.eu set account permission multisigperm active '{"threshold":2,"keys":[],"accounts":[{"permission":{"actor":"multisigsig1","permission":"active"},"weight":1},{"permission":{"actor":"multisigsig2","permission":"active"},"weight":1},{"permission":{"actor":"multisigsig3","permission":"active"},"weight":1}],"waits":[]}' owner -p multisigperm@owner
# cleos -u http://testnet.telos.eossweden.eu set account permission multisigperm owner '{"threshold":2,"keys":[],"accounts":[{"permission":{"actor":"multisigsig1","permission":"active"},"weight":1},{"permission":{"actor":"multisigsig2","permission":"active"},"weight":1},{"permission":{"actor":"multisigsig3","permission":"active"},"weight":1}],"waits":[]}'  -p multisigperm@owner

cleos -u http://testnet.telos.eossweden.eu push action -sjd -x 86400 eosio.token transfer '["multisigperm","multisigsig1","1.1000 TLOS","multisig test"]' -p multisigsig1 > trx.json
cleos -u http://testnet.telos.eossweden.eu multisig propose_trx testxfer '[{"actor": "multisigsig1", "permission": "active"}, {"actor": "multisigsig2", "permission": "active"}, {"actor": "multisigsig3", "permission": "active"}]' ./trx.json multisigprop

cleos -u http://testnet.telos.eossweden.eu multisig review multisigprop testxfer
cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addproposal '["multisigprop", "testxfer", "This is a proposal to send 1.1 TLOS", "https://mon-test.telosfoundation.io/account/multisigapp1", "1 DAY"]' -p multisigprop
cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[0, 1, "multisigsig1"]' -p multisigprop
cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[0, 2, "multisigsig2"]' -p multisigprop
cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 addapprover '[0, 3, "multisigsig3"]' -p multisigprop

cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 approve '["multisigsig1", 0]' -p multisigsig1
cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 approve '["multisigsig2", 1]' -p multisigsig2
cleos -u http://testnet.telos.eossweden.eu push action multisigapp1 approve '["multisigsig3", 2]' -p multisigsig3