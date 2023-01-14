// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface Staking_Standard {

    function deposit(address tokenAddress,address userAddress, uint256 amount) external;
    function withdraw(address tokenAddress,address userAddress, uint256 amount) external ;
    function pendingReward(address account) external view returns (uint256);
    function autoCompound(address tokenAddress, uint256 amount) external returns (uint256);
    
    function isCoolDownStaking() external view returns(bool);
    function getCooldownActivatedTime() external view returns(uint);
    function getWithdrawingWindowInterval() external view returns(uint);
    function getDefaultCooldownInterval() external view returns(uint);
    

    function activateCooldown(address _userAddress, uint _amount) external;
   // function currentUnstakingAmount() external view returns(bool);

}