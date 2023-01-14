// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


interface BICO_Interface {
    function stake(address onBehalfOf, uint256 amount) external ;
    function redeem(address to, uint256 amount) external;
    function claimRewards(address to, uint256 amount) external ;
    function cooldown() external ;
    function getTotalRewardsBalance(address staker) external view returns (uint256);
    function UNSTAKE_WINDOW() external view returns (uint256);
    function COOLDOWN_SECONDS() external view returns (uint256);
    function stakersCooldowns(address staker) external view returns (uint256);
    
    
}