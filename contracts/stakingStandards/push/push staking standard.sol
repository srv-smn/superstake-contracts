// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../../interface/StakingStandard.sol";

import "../../interface/IERC20.sol";
import "./Ipush.sol";

interface IYieldFarm {
    function massHarvest() external returns (uint);
}

contract Push_Staking is Staking_Standard{
    Push_Interface push ;
    IYieldFarm yield ;
    
    constructor(address _pushStake, address _yieldAddress) {
        push = Push_Interface(_pushStake);
        yield = IYieldFarm(_yieldAddress);
    }

    // deposit
     function deposit(address tokenAddress,address userAddress, uint256 amount) public virtual override{
         IERC20(tokenAddress).approve(address(push),amount);
         push.deposit(tokenAddress, amount);
     }

    // withdraw
     function withdraw(address tokenAddress, address userAddress, uint256 amount) public virtual override {
        push.withdraw(tokenAddress, amount);
        IERC20(tokenAddress).transfer(userAddress,amount);
    }
     
    // reward
    function pendingReward(address account) public virtual override view returns (uint256){
        
    }

    // autocompound
    function autoCompound(address tokenAddress, uint256 amount) public virtual override returns (uint256){
        yield.massHarvest();
        uint pushBalance = IERC20(tokenAddress).balanceOf(address(this));
        IERC20(tokenAddress).approve(address(push),pushBalance);
        push.deposit(tokenAddress, pushBalance);
        return pushBalance;
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