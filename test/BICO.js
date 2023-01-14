require("dotenv").config();
const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = require("ethers");
const helpers = require("@nomicfoundation/hardhat-network-helpers");
const { mine } = require("@nomicfoundation/hardhat-network-helpers");

describe("BICO Contract:", async function () {

    let firstUser, secondUser,impersonatedSigner;
    let superstakeContract, BICOStandard, userSpecificAddress, userSpecificContract;
    let Bico, BicoStaking, stkBico;
    let testAmount = '1000000000000000000'
    let testUnstakeAmount = '100000000000000000'

      const BicoAddress = '0xDdc47b0cA071682e8dc373391aCA18dA0Fe28699'
      const BicoStakingAddress = '0x542Eb2c8c1b58143054Ed51b855985728B85E918'
      const stkBicoAddress = '0x542Eb2c8c1b58143054Ed51b855985728B85E918'
     
  
    before(async () => {
      
      [firstUser, secondUser] = await ethers.getSigners();
      const address = "0x553190A7e818fFbe60a19b650579683091c860cC";
       await helpers.impersonateAccount(address);
      impersonatedSigner = await ethers.getSigner(address);
      
      Bico = await ethers.getContractAt("contracts/interface/IERC20.sol:IERC20", BicoAddress);
      stkBico = await ethers.getContractAt("contracts/interface/IERC20.sol:IERC20", stkBicoAddress);
      BicoStaking = await ethers.getContractAt("BICO_Interface", stkBicoAddress);
      console.log('Before:', firstUser.address);
      console.log('Before:', secondUser.address);
      console.log('Before:', impersonatedSigner.address);
 
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

  it("Check user 1 balance of BICO", async function () {
    const isUnstakingAllowed = await Bico.balanceOf(firstUser.address)
    console.log(isUnstakingAllowed);
  });

  it("Giving approval from firstuser to superstake", async function () {
    const w_Bico = await Bico.connect(firstUser).approve(superstakeContract.address,testAmount)
    await w_Bico.wait();
    const allowance = await Bico.allowance(firstUser.address, superstakeContract.address);
    expect(allowance).to.equal(testAmount);
  });

  it("Staking Bico: first user", async function () {
    const w_superstakeContract = await superstakeContract.connect(firstUser).Stake([BicoAddress],[testAmount])
    await w_superstakeContract.wait();
    const balanceLength = await superstakeContract.getStakingLength(firstUser.address, BicoAddress)
    expect(balanceLength).to.equal(1);
    
  });

  it("checking staking balance: firstuser", async function () {
    const balanceLength = await superstakeContract.getStakingLength(firstUser.address, BicoAddress)
    const balanceStruct = await superstakeContract.balances(firstUser.address, BicoAddress,balanceLength-1)
     expect(balanceStruct.amount).to.equal(testAmount);
  });

  it("checking stkBICO balance in protocol standard", async function () {
    const balance = await stkBico.balanceOf(BICOStandard.address)
     expect(balance).to.equal(testAmount);
  });

  it("increasing timestamp to check if reward is generated og not", async function () {

    await mine(2000);
    // TODO: uncomment in future
    //await superstakeContract.connect(firstUser).autoCompond(BicoAddress, BicoAddress)
    const balance = await BICOStandard.pendingReward(BICOStandard.address)

    console.log('-------->', balance);
    console.log('----in eth---->', parseFloat(ethers.utils.formatEther(balance.mod(1e14))).toFixed(6));
    expect(parseFloat(parseFloat(ethers.utils.formatEther(balance.mod(1e14))).toFixed(6))).to.be.greaterThan(0);
    
  });

  it("Doing auto compounding", async function () {
    let Bbalance, Abalance;
    Bbalance = await stkBico.balanceOf(BICOStandard.address)

    console.log('balance before auto compound', Bbalance);
    const t = await superstakeContract.connect(firstUser).autoCompond(BicoAddress, BicoAddress)
    await t.wait()

    Abalance = await stkBico.balanceOf(BICOStandard.address)
    console.log('balance after auto compound', Abalance);
    expect(parseFloat(ethers.utils.formatEther(Abalance.mod(1e14))).toFixed(6) - parseFloat(ethers.utils.formatEther(Bbalance.mod(1e14))).toFixed(6)).to.be.greaterThan(0)
    
  });


  it("activating cooldown for Bico: impersonatedSigner", async function () {
    const balanceLength = await superstakeContract.getStakingLength(firstUser.address, BicoAddress)
    const w_superstakeContract = await superstakeContract.connect(firstUser).unStake(Bico.address,balanceLength-1)
    await w_superstakeContract.wait();
     userSpecificAddress = await BICOStandard.userAddress(firstUser.address)
    console.log('userSpecificAddr', userSpecificAddress);
    expect(userSpecificAddress).to.be.equal.toString();
    
  });

  it("checking stkBICO balance in user specific contract", async function () {
    const balance = await stkBico.balanceOf(userSpecificAddress)
     expect(balance).to.equal(testAmount);
    
  });

  it("checking staking balance in superstake contract: impersonatedSigner", async function () {
    const balanceLength = await superstakeContract.getStakingLength(firstUser.address, BicoAddress)
    //const balanceStruct = await superstakeContract.balances(firstUser.address, BicoAddress,balanceLength-1)
     expect(balanceLength).to.equal(0);
  });

  it("cooldown start time should be less than current time", async function () {
    userSpecificContract = await ethers.getContractAt("userContract", userSpecificAddress);
    const cooldownStartTime = await userSpecificContract.getCooldownActivatedTime(BicoStaking.address, Bico.address, stkBico.address, testAmount)
    // console.log('cooldown end time from contract', cooldownStartTime);
    // console.log('time stamp in js ',Math.floor(Date.now() / 1000)); 
    const cooldownInterval = await userSpecificContract.getDefaultCooldownInterval(BicoStaking.address, Bico.address, stkBico.address, testAmount)
    console.log('eligible to unstake at ', cooldownInterval);
    expect(parseInt(cooldownStartTime.toString())).to.lessThan(Math.floor(Date.now() / 1000)+2010);
  });

  it("unstaking window: should be greater than 0", async function () { 
    const cooldownInterval = await userSpecificContract.getWithdrawingWindowInterval(BicoStaking.address, Bico.address, stkBico.address, testAmount)
    console.log('eligible to unstake at ', cooldownInterval);
    expect(parseInt(cooldownInterval.toString())).to.greaterThan(0);
  });

  // it("unstaking window: should be greater than 0", async function () { 
  //   // const cooldownInterval = await userSpecificContract.getWithdrawingWindowInterval(BicoStaking.address, Bico.address, stkBico.address, testAmount)
  //   // console.log('eligible to unstake at ', cooldownInterval);
  //   // expect(parseInt(cooldownInterval.toString())).to.greaterThan(0);
  //   const blockNumBefore = await ethers.provider.getBlockNumber();
  //   const blockBefore = await ethers.provider.getBlock(blockNumBefore);
  //   //await ethers.provider.send("evm_mine", [blockBefore.timestamp+1900]);
  //   await mine(1000);
  //   const afterNumBefore = await ethers.provider.getBlockNumber();
  //   const blockAfter = await ethers.provider.getBlock(afterNumBefore);


  //   // console.log('blockNumBefore', blockNumBefore, blockBefore.timestamp);
  //   // console.log('afterNumBefore', afterNumBefore, blockAfter.timestamp);
  // });

  it("trying to unstake before the cooldown ends: INSUFFICIENT_COOLDOWN", async function () { 
    //const cooldownInterval = await userSpecificContract.withdraw(Bico.address, stkBico.address,BicoStaking.address, testAmount)
    await expect(userSpecificContract.withdraw(Bico.address, stkBico.address,BicoStaking.address, testAmount)).to.be.revertedWith('INSUFFICIENT_COOLDOWN')
  });

  it("Unstaking it after cooldown and before unstaking window", async function () { 
    //const cooldownInterval = await userSpecificContract.withdraw(Bico.address, stkBico.address,BicoStaking.address, testAmount)
    let userBalance = await Bico.balanceOf(firstUser.address)
    console.log('user balance before unstaking',userBalance.toString());
    await mine(2000);
    let rewardGenerated = await userSpecificContract.pendingReward(BicoStaking.address, Bico.address, stkBico.address, testAmount)
    console.log('rewardGenerated',rewardGenerated);
    
    await userSpecificContract.connect(firstUser).withdraw(Bico.address, stkBico.address,BicoStaking.address, testUnstakeAmount)
     userBalance = await Bico.balanceOf(firstUser.address)
     console.log('requested unstaking amount',testUnstakeAmount)
    console.log('user balance after unstaking',userBalance.toString())
  });

  it("trying to unstake after the cooldown ends + unstake window: UNSTAKE_WINDOW_FINISHED", async function () { 
    //const cooldownInterval = await userSpecificContract.withdraw(Bico.address, stkBico.address,BicoStaking.address, testAmount)
    await mine(7200);
    await expect(userSpecificContract.withdraw(Bico.address, stkBico.address,BicoStaking.address, testUnstakeAmount)).to.be.revertedWith('UNSTAKE_WINDOW_FINISHED')
  });

  
    
    
  });