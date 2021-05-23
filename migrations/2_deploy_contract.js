const Voting = artifacts.require('Voting');
const {address} = require('../env.json');

const ether = (n) => web3.utils.toWei(n, 'ether');


module.exports = function (deployer, network) {
    deployer.then(async () => {
        if (network === 'dev') {
        } else if (network == 'testnet') {
            await deployer.deploy(Voting);
        }
    })
};
