// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../../interface/IERC20.sol";
import "../../interface/StakingStandard.sol";
import "../../interface/IUser.sol";
import "./Ibico.sol";

 contract userContract is IUser{

    mapping (address => uint ) public eligible_unstake_amount;
    address public superStake;
    address public user;


    constructor(address _user ) {
       superStake = msg.sender;
       user = _user;
    }

    

    // withdraw
     function withdraw(address _tokenAddress, address _stkTokenAddress, address _stakingAddress, uint256 amount) public virtual override {
       IERC20 token = IERC20(_tokenAddress);
       IERC20 stkToken = IERC20(_stkTokenAddress);
       BICO_Interface staking = BICO_Interface(_stakingAddress);

       // claiming pending reward
       uint unclaimedReward = staking.getTotalRewardsBalance(address(this));
       staking.claimRewards(address(this), unclaimedReward);
       
        // unstaking
       stkToken.approve(_stakingAddress,amount);
       staking.redeem(address(this), amount);
        // transfer to user
       token.transfer(user, token.balanceOf(address(this)));

    }


    // reward
    function pendingReward(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) public virtual override view returns (uint256){
         BICO_Interface staking = BICO_Interface(_stakingAddress);
        uint unclaimedReward = staking.getTotalRewardsBalance(address(this));
        return unclaimedReward;
    }


     function getCooldownActivatedTime(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) external override view returns(uint){
         BICO_Interface staking = BICO_Interface(_stakingAddress);
         return staking.stakersCooldowns(address(this));
     }

     function getWithdrawingWindowInterval(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) external override view returns(uint){
          BICO_Interface staking = BICO_Interface(_stakingAddress);
         return staking.UNSTAKE_WINDOW();
     }

     function getDefaultCooldownInterval(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) external override view returns(uint){
          BICO_Interface staking = BICO_Interface(_stakingAddress);
         return staking.COOLDOWN_SECONDS();
     }
    
    

     function activateCooldown(address _stakingAddress, address _tokenAddress, address stkToken, uint _amount) public virtual override {
        
        //eligible_unstake_amount[_tokenAddress] =  
        BICO_Interface staking = BICO_Interface(_stakingAddress);
        staking.cooldown();
    }

    function deployedFor() external view override returns(address) {
        return user ;
    }

    function transferTokens(address _tokenAddress, uint _amount, bool _toSS) external override{

        IERC20 token =  IERC20(_tokenAddress);
        uint balance = token.balanceOf(address(this));
        require(balance >= _amount, 'amount more than balance');

        if(_toSS){
            token.transfer(superStake, _amount);
        } else {
            token.transfer(user, _amount);
        }
    }
   
}
