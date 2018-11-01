var StarNotary = artifacts.require("./StarNotary.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(StarNotary,{from: accounts[0]})
  .then(function() {
    return StarNotary.address;
  });
};
