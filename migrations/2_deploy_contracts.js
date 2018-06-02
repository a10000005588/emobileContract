var SafeMath = artifacts.require("../contracts/SafeMath.sol");
var Fund = artifacts.require("../contracts/Fund.sol");
var Emoto = artifacts.require("../contracts/Emoto.sol");
var Driver = artifacts.require("../contracts/Driver.sol");
var EMOToken = artifacts.require("../contracts/EMOToken.sol");

module.exports = function(deployer) {
    deployer.deploy(SafeMath)
        .then( () => deployer.deploy(EMOToken))
        .then( () => deployer.deploy(Fund, EMOToken.address))
        .then( () => deployer.deploy(Driver))
        .then( () => deployer.deploy(Emoto, Driver.address, Fund.address));
};
