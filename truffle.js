var env = require("./env.js");
var WalletProvider = require("truffle-wallet-provider");
var Wallet = require('ethereumjs-wallet');
var rinkebyPrivateKey = new Buffer(env.RINKEBY_PRIVATE_KEY, "hex");
var rinkebyWallet = Wallet.fromPrivateKey(rinkebyPrivateKey);
var rinkebyProvider = new WalletProvider(rinkebyWallet, env.RINKEBY_HTTP_PROVIDER);

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      network_id: 3,
      host: "localhost",
      port:  8545,
      gas:   4700000
    },
    rinkeby: {
      host: "localhost", // Connect to geth on the specified
      port: 8545,
      from: "0x384df9cfa17607b96b00c2d1d51a6c65d154906c", // default address to use for any transaction Truffle makes during migrations
      network_id: 4,
      gas: 4700000 // Gas limit used for deploys
    },
    infuraRinkeby: {
      provider: rinkebyProvider,
      network_id: 4
    },
  },
  rpc: {
    host: 'localhost',
    post:8080
  }
};


