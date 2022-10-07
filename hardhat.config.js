/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.7",
      },
      {
        version: "0.7.6",
      }
    ],
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
    // forking:{
        allowUnlimitedContractSize: true,
    //     url: process.env.GOERLI,
    //     accounts: [`0x${process.env.ACCOUNT1}`, `0x${process.env.ACCOUNT2}`],
    //  }
    },
    goerli: {
      url: process.env.GOERLI,
      accounts: [`0x${process.env.ACCOUNT1}`, `0x${process.env.ACCOUNT2}`],
      chainId: 5,
      allowUnlimitedContractSize: true,
      blockGasLimit: 100000000429720
    },
  }
};
