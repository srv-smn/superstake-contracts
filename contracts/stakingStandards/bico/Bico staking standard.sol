// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './userSpecific.sol';
import "../../interface/StakingStandard.sol";


 contract Bico_Staking is Staking_Standard{

    IERC20 public BICO;
    IERC20 public stkBICO;
    BICO_Interface staking;
    bool private is_Cooldown_Staking;
    uint public eligible_unstake_amount =0;
    mapping(address => address) public userAddress; 


    constructor(address _stakingContract, address _BICO, address _stkBICO, bool _is_Cooldown_Staking) {
        BICO = IERC20(_BICO);
        stkBICO = IERC20(_stkBICO);
        staking = BICO_Interface(_stakingContract); 
        is_Cooldown_Staking = _is_Cooldown_Staking;
    }

    // deposit
    function deposit(address tokenAddress,address _userAddress, uint256 amount) public virtual override {
        BICO.approve(address(staking),amount);
        staking.stake(address(this), amount);
    }

    // withdraw
     function withdraw(address tokenAddress, address _userAddress, uint256 amount) public virtual override {
    //    stkBICO.approve(address(staking),amount);
    //    staking.redeem(_userAddress, amount);
            this.activateCooldown(_userAddress, amount);
    
    }


    // reward
    function pendingReward(address account) public virtual override view returns (uint256){
        uint unclaimedReward = staking.getTotalRewardsBalance(address(this));
        return unclaimedReward;
    }

    function autoCompound(address tokenAddress, uint256 amount) public virtual override returns (uint256){
        uint unclaimedReward = staking.getTotalRewardsBalance(address(this));
        staking.claimRewards(address(this), unclaimedReward);

        BICO.approve(address(staking),unclaimedReward);
        staking.stake(address(this), unclaimedReward);
    }



     function isCoolDownStaking() external override view returns(bool){
         return is_Cooldown_Staking;
     }

     function getCooldownActivatedTime() external override view returns(uint){
         return staking.stakersCooldowns(address(this));
     }

     function getWithdrawingWindowInterval() external override view returns(uint){
         return staking.UNSTAKE_WINDOW();
     }

     function getDefaultCooldownInterval() external override view returns(uint){
         return staking.COOLDOWN_SECONDS();
     }
    
    

     function activateCooldown(address _userAddress, uint _amount) public virtual override {
        // eligible_unstake_amount = 
        //staking.cooldown();

        if(userAddress[_userAddress] == address(0)){
            userContract userReg = new userContract(_userAddress);
            userAddress[_userAddress] = address(userReg);
        }

        userContract user = userContract(userAddress[_userAddress]);
        stkBICO.transfer(userAddress[_userAddress], _amount);
        user.activateCooldown(address(staking), address(BICO), address(stkBICO), _amount);

    }
   // function currentUnstakingAmount() external view returns(bool);

   function addUserAddess(address _user, address _userSCA) public {
       userAddress[_user] = _userSCA;
   }

}

// staking: 0x7263372b9ff6E619d8774aEB046cE313677E2Ec7
// OHM: 0x0595328847AF962F951a4f8F8eE9A3Bf261e4f6b
// SOHM: 0x4EFe119F4949319f2Acb12efD615a7B63896482B
