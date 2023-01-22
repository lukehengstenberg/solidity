const erc20Token = artifacts.require("./erc20Token.sol");
const SupplyChain = artifacts.require("./SupplyChain.sol");

module.exports = function (deployer) {
  deployer.deploy(erc20Token, 10000, "illLeJiTimatt token", 18, "ILJTM");
  deployer.deploy(SupplyChain);
};
