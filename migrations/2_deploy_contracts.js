var Math = artifacts.require("../contracts/Math.sol");
var Emobile = artifacts.require("../contracts/Emobile.sol");
var Driver = artifacts.require("../contracts/Driver.sol");

module.exports = function(deployer) {
    deployer.deploy(Math)
        .then( () => deployer.deploy(Math))
        .then( () => deployer.deploy(Emobile))
        .then( () => deployer.deploy(Driver));
};
