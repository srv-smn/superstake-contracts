require("dotenv").config();
const { ethers } = require("hardhat");
const { BigNumber } = require("ethers");

async function main() {
    console.log('Hie ');
      const BicoAddress = '0xDdc47b0cA071682e8dc373391aCA18dA0Fe28699'
      const BicoStakingAddress = '0x542Eb2c8c1b58143054Ed51b855985728B85E918'
      const stkBicoAddress = '0x542Eb2c8c1b58143054Ed51b855985728B85E918'
      let superstakeContract, BICOStandard, userSpecificAddress, userSpecificContract;

    //   const t_superstakeContract = await ethers.getContractFactory("SuperStakeV2");
    //   superstakeContract = await t_superstakeContract.deploy();
    //   await superstakeContract.deployed();
    //   console.log("superstakeContract contract deployed at : ", superstakeContract.address);

    //   const t_BicoStandard = await ethers.getContractFactory("Bico_Staking");
    // BICOStandard = await t_BicoStandard.deploy(BicoStakingAddress, BicoAddress, stkBicoAddress, true);
    // await BICOStandard.deployed();
    // console.log("BICOStandard contract deployed at : ", BICOStandard.address);

    superstakeContract = await ethers.getContractAt("SuperStakeV2", BicoAddress);

    const w_superstakeContract = await superstakeContract.addProtocols(BicoAddress,'0x4Eb30c9BeC6db965219875dB7825512ceB4FaF4D',false)
    await w_superstakeContract.wait();
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  