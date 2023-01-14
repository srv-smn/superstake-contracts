// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface Push_Interface {

    function deposit(address tokenAddress, uint256 amount) external;
    function withdraw(address tokenAddress, uint256 amount) external ;
    function balanceOf(address user, address token) external view returns (uint256) ;

}