const HDWalletProvider = require('truffle-hdwallet-provider');
const infuraKey = 'baa580d7e24c41bcb71295d5a28e3174';
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
	networks: {
		development: {
			host: "localhost",
			port: 7545,
			network_id: "*" // Match any network id
		},
		ropsten: {
		provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/bb8ad7bd0d544b0aad421d5d8bd5562b`),
		network_id: 3,       // Ropsten's id
		gas: 5500000,        // Ropsten has a lower block limit than mainnet
		confirmations: 2,    // # of confs to wait between deployments. (default: 0)
		timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
		skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
		}
	},
	compilers: {
		solc: {
			version: "0.5.12",    // Fetch exact version from solc-bin (default: truffle's version)
			// docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
			// settings: {          // See the solidity docs for advice about optimization and evmVersion
			//  optimizer: {
			//    enabled: false,
			//    runs: 200
			//  },
			//  evmVersion: "byzantium"
			// }
		},
	}
};
