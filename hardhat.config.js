require("@nomiclabs/hardhat-waffle");
require('@openzeppelin/hardhat-upgrades');
require("@nomiclabs/hardhat-etherscan");
require('hardhat-contract-sizer');
require('hardhat-abi-exporter');

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**ss
 * @type import('hardhat/config').HardhatUserConfig
 */
const ALCHEMY_API_KEY = `GKcZh-E7o6PB3gEz0M9fUHPwG4_xHbbj`
const privateKey = `bdfd01d7d91bcb0bcd07c90b00b919e507a8625009e3a9712743ad543a3398da`

module.exports = {
  solidity: "0.8.0",
  networks: {
    ropsten: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${privateKey}`],
      chainId:3,
    },
    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${privateKey}`],
      chainId:4,
    },
  },
  etherscan: {
    // Your API key for Etherscan JEXEYX2UI96YT1PV6CS4E249CDPGP4B2EN
    // Obtain one at https://etherscan.io/
    apiKey: "FJ3T8BIFY6TUT93M3KGTP8WGDISYJSG2NU"
  },
  contractSizer: {
    alphaSort: true,
    disambiguatePaths: false,
    runOnCompile: true,
    strict: true,
    only: [':Account$',':AccountDeployer$',':Admin$',':Badge$',':Wallet$'],
  },
  
  abiExporter: {

    path: "./package/contracts/",
    runOnCompile: false,
    clear: false,
    only: [':Account$',':AccountDeployer$',':Admin$',':Badge$',':Wallet$',':ERC2099starz$'],
    flat: true,
    spacing: 2,
    pretty: true,
    
  }
};
//https://eth-rinkeby.alchemyapi.io/v2/GKcZh-E7o6PB3gEz0M9fUHPwG4_xHbbj
//npx hardhat verify --network ropsten 0xb2fd5eD8C3Fb770512f165019970EA14A092587e
// 0x2da9e83EfEA29968174f1Cbf724c3d323272Aa25
// 0x3B2FA3fB4c7eD3bC495F276DC60782b635bB04d9