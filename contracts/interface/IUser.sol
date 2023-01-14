// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface IUser {

    function withdraw(address _tokenAddress, address _stkTokenAddress, address _stakingAddress, uint256 amount) external ;
    function pendingReward(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) external view returns (uint256);
    function deployedFor() external view returns(address);
    function transferTokens(address _tokenAddress, uint _amount, bool _toAdmin) external;
    
    function getCooldownActivatedTime(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) external view returns(uint);
    function getWithdrawingWindowInterval(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) external view returns(uint);
    function getDefaultCooldownInterval(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) external view returns(uint);
    

    function activateCooldown(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) external;
   // function currentUnstakingAmount() external view returns(bool);

}