require("dotenv").config();
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require("ethers");


describe("BICO Contract:", async function () {

    let firstUser, secondUser;
    let superstakeContract, BICOStandard;
    let Bico, BicoStaking, stkBico;

      const BicoAddress = '0xDdc47b0cA071682e8dc373391aCA18dA0Fe28699'
      const BicoStakingAddress = '0x317108B9bE69C86c21E33af7BC097F4Aa3525e1D'
      const stkBicoAddress = '0x317108B9bE69C86c21E33af7BC097F4Aa3525e1D'
     
  
    before(async () => {
      
      [firstUser, secondUser] = await ethers.getSigners();

      Bico = await ethers.getContractAt("contracts/superstakeV2.sol:ERC20", BicoAddress);
      stkBico = await ethers.getContractAt("contracts/superstakeV2.sol:ERC20", stkBicoAddress);
      BicoStaking = await ethers.getContractAt("BICO_Interface", stkBicoAddress);
      console.log('Before:', firstUser.address);
      console.log('Before:', secondUser.address);
 
    });

    // Deploy contracts
    it("Should deploy superstake contract", async function () {
      const t_superstakeContract = await ethers.getContractFactory("SuperStakeV2");
      superstakeContract = await t_superstakeContract.deploy();
      await superstakeContract.deployed();
      console.log("superstakeContract contract deployed at : ", superstakeContract.address);
  });

  it("Should deploy Bico standard contract", async function () {
    const t_BicoStandard = await ethers.getContractFactory("Bico_Staking");
    BICOStandard = await t_BicoStandard.deploy(BicoStakingAddress, BicoAddress, stkBicoAddress, true);
    await BICOStandard.deployed();
    console.log("BICOStandard contract deployed at : ", BICOStandard.address);
  });

  it("Register Bico Protocol with Superstake", async function () {
    const w_superstakeContract = await superstakeContract.connect(firstUser).addProtocols(BicoAddress,BICOStandard.address,false)
    await w_superstakeContract.wait();
    const protocol = await superstakeContract.protocols(BicoAddress)
    expect(protocol).to.equal(BICOStandard.address);
  });

  it("Check Staking is allowed for BICO", async function () {
    const isStakingAllowed = await superstakeContract.isStakingAllowed(BicoAddress)
    expect(isStakingAllowed).to.equal(true);
  });

  it("Check UnStaking is allowed for BICO", async function () {
    const isUnstakingAllowed = await superstakeContract.isUnstakingAllowed(BicoAddress)
    expect(isUnstakingAllowed).to.equal(true);
  });

  it("Giving approval from user2 to superstake", async function () {
    const w_Bico = await Bico.connect(secondUser).approve(superstakeContract.address,'1000000000000000000')
    await w_Bico.wait();
    const allowance = await Bico.allowance(secondUser.address, superstakeContract.address);
    expect(allowance).to.equal('1000000000000000000');
  });

  it("Staking Bico: user2", async function () {
    const b = await Bico.balanceOf(secondUser.address);
    console.log(secondUser.address,b);
    const w_superstakeContract = await superstakeContract.connect(secondUser).Stake([BicoAddress],['1000000000000000000'])
    await w_superstakeContract.wait();
    const balanceStruct = await superstakeContract.balances(secondUser.address, BicoAddress)
    expect(balanceStruct.amount).to.equal('1000000000000000000');
  });
  
    
    
  });