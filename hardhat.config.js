/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
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
     forking:{
        allowUnlimitedContractSize: true,
        //url: process.env.GOERLI,
        url: 'https://goerli.infura.io/v3/1ec6558c6dba4a9db1ab5f5b647d9a60',
        //accounts: [`0x${process.env.ACCOUNT1}`, `0x${process.env.ACCOUNT2}`],
     }
    },
    goerli: {
      url: process.env.GOERLI,
      accounts: [`0x${process.env.ACCOUNT1}`, `0x${process.env.ACCOUNT2}`],
      chainId: 5,
      allowUnlimitedContractSize: true,
      blockGasLimit: 100000000429720
    },
  },
  etherscan: {
    apiKey: "9H8SHXVRIPRCJG8YT56EEVPMYRU5I6C6CG",
  },
};
