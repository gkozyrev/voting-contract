const HDWalletProvider = require('@truffle/hdwallet-provider');
const {mnemonic, BSCSCANAPIKEY} = require('./env.json');

module.exports = {
    plugins: ['truffle-plugin-verify', 'solidity-coverage'],
    api_keys: {
        bscscan: BSCSCANAPIKEY,
    },
    networks: {
        dev: {
            host: '127.0.0.1',
            port: 7545,
            network_id: '*',
        },
        testnet: {
            provider: () => new HDWalletProvider(mnemonic, 'https://data-seed-prebsc-1-s1.binance.org:8545'),
            network_id: 97,
            confirmations: 2,
            skipDryRun: true,
            networkCheckTimeout: 50000000,
            timeoutBlocks: 2000,
        },
    },
    compilers: {
        solc: {
            version: '^0.8.0',
            settings: {
                optimizer: {
                    enabled: true,
                },
                evmVersion: 'byzantium',
            },
        },
    },
};
