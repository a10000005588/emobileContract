var SafeMath = artifacts.require("../contracts/SafeMath.sol");
var Fund = artifacts.require("../contracts/Fund.sol");
var Emoto = artifacts.require("../contracts/Emoto.sol");
var Driver = artifacts.require("../contracts/Driver.sol");

module.exports = function(deployer) {
    deployer.deploy(SafeMath)
        .then( () => deployer.deploy(Fund))
        .then( () => deployer.deploy(Emoto))
        .then( () => deployer.deploy(Driver));
};
