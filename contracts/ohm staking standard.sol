// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


interface Staking_Standard {

    function deposit(address tokenAddress,address userAddress, uint256 amount) external;
    function withdraw(address tokenAddress,address userAddress, uint256 amount) external ;
    function pendingReward(address account) external view returns (uint256);
    function autoCompound(address tokenAddress, uint256 amount) external returns (uint256);
}


interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}



interface OHM_Interface {
    function stake(address _to, uint256 _amount, bool _rebasing, bool _claim) external returns (uint256);
    function unstake(address _to, uint256 _amount, bool _trigger, bool _rebasing) external returns (uint256 amount_);
}

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





}

// staking: 0x7263372b9ff6E619d8774aEB046cE313677E2Ec7
// OHM: 0x0595328847AF962F951a4f8F8eE9A3Bf261e4f6b
// SOHM: 0x4EFe119F4949319f2Acb12efD615a7B63896482B
