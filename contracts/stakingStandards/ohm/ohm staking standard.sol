// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


import "../../interface/StakingStandard.sol";
import "../../interface/IERC20.sol";
import "./Iohm.sol";

contract Ohm_Staking is Staking_Standard{

    IERC20 OHM;
    IERC20 sOHM;
    OHM_Interface staking;

    constructor(address _stakingContract, address _OHM, address _sOHM) {
        OHM = IERC20(_OHM);
        sOHM = IERC20(_sOHM);
        staking = OHM_Interface(_stakingContract);
    }

    function deposit(address tokenAddress,address userAddress, uint256 amount) public virtual override {
        OHM.approve(address(staking),amount);
        staking.stake(address(this), amount, true, true);
    }

    // withdraw
     function withdraw(address tokenAddress, address userAddress, uint256 amount) public virtual override {
       sOHM.approve(address(staking),amount);
       staking.unstake(address(this), amount, false,true);
       OHM.transfer(userAddress,amount);
    }


    // reward
    function pendingReward(address account) public virtual override view returns (uint256){
        
    }

    function autoCompound(address tokenAddress, uint256 amount) public virtual override returns (uint256){
        
    }

    function isCoolDownStaking() external override view returns(bool){
         return false;
     }

     function getCooldownActivatedTime() external override view returns(uint){
         return 0;
     }

     function getWithdrawingWindowInterval() external override view returns(uint){
         return 0;
     }

     function getDefaultCooldownInterval() external override view returns(uint){
         return 0;
     }
    
    

     function activateCooldown(address _userAddress, uint _amount) public virtual override {


    }





}

// staking: 0x7263372b9ff6E619d8774aEB046cE313677E2Ec7
// OHM: 0x0595328847AF962F951a4f8F8eE9A3Bf261e4f6b
// SOHM: 0x4EFe119F4949319f2Acb12efD615a7B63896482B
