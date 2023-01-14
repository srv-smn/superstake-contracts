// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface OHM_Interface {
    function stake(address _to, uint256 _amount, bool _rebasing, bool _claim) external returns (uint256);
    function unstake(address _to, uint256 _amount, bool _trigger, bool _rebasing) external returns (uint256 amount_);
}