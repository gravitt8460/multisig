const fs = require("fs")
const path = require("path")

const dir = '.'
const wasmFileName = '../token/token.wasm'//dirCont.find(filePath => filePath.match(/.*\.(wasm)$/gi))
const abiFileName = '../token/token.abi' //dirCont.find(filePath => filePath.match(/.*\.(abi)$/gi))

// if (!wasmFileName) throw new Error(`Cannot find a ".wasm file" in ${dir}`)
// if (!abiFileName) throw new Error(`Cannot find an ".abi file" in ${dir}`)
//     return {
//         wasmPath: path.join(dir, wasmFileName),
//         abiPath: path.join(dir, abiFileName),
//     }


const wasm = fs.readFileSync(wasmFileName).toString(`hex`)
console.log (wasm)


const { Api, JsonRpc, RpcError, JsSignatureProvider } = require('eosjs');
const fetch = require('node-fetch');                            // node only; not needed in browsers
const { TextEncoder, TextDecoder } = require('util');           // node only; native TextEncoder/Decoder

const defaultPrivateKey = "5JdjwzuhqaGBn8ZFJW5Jgg2MgbpNdxYumpWFhgvqWPZVPedmR1k"; // useraaaaaaaa
const signatureProvider = new JsSignatureProvider([defaultPrivateKey]);

const rpc = new JsonRpc('https://jungle.eosio.cr:443', { fetch });

const api = new Api({ rpc, signatureProvider, textDecoder: new TextDecoder(), textEncoder: new TextEncoder() });


try {
    (async () => {
        const result = await api.transact({
            actions: [{
                account: 'eosio',
                name: 'propose',
                authorization: [{
                  actor: 'gyftieuser11',
                  permission: 'active',
                }],
                data: {
                  proposer: 'gyftieuser11',
                  token_gen: 'gygenesisgen',
                  notes: 'Back to genesis gen'
                },
              }]
          }, {
              blocksBehind: 3,
              expireSeconds: 30,
          });
        console.dir(result);
      })();
  } catch (e) {
    console.log('\nCaught exception: ' + e);
    if (e instanceof RpcError)
      console.log(JSON.stringify(e.json, null, 2));
  }

