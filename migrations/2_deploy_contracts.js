var COIN_FLIP = artifacts.require("./CoinFlip.sol");

module.exports = function(inDeployer)
{
	inDeployer.deploy(COIN_FLIP);
};
