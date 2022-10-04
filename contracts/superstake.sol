// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface ERC20 {
    
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface Staking_Standard {

    function deposit(address tokenAddress,address userAddress, uint256 amount) external;
    function withdraw(address tokenAddress,address userAddress, uint256 amount) external ;
    function pendingReward(address account) external view returns (uint256);
    function autoCompound(address tokenAddress, uint256 amount) external returns (uint256) ;
}

// adding modifiers is pending
contract SuperStakeV2 {
    struct stake{
        uint amount;
        uint withdrawTime;
    }

    //mapping(address => mapping(address => stake[])) public balances;
    mapping(address => mapping(address => uint)) public balances;
    mapping(address => address) public protocols;
    mapping(address => bool) public isStakingAllowed;
    mapping(address => bool) public isUnstakingAllowed;
    address public Push = 0x7bb36F95c382C895473E091052C51bFb7d2e9E37;

    event Deposit(address indexed user, address indexed tokenAddress, uint256 amount);
    event Withdraw(address indexed user, address indexed tokenAddress, uint256 amount);
    event AutoCompund(address indexed tokenAddress, uint256 amount);
    event ProtocolAdded(address tokenAddress, address protocolAddress);


    function Stake(address[] calldata tokenAddress, uint256[] calldata amount) public {
        require(tokenAddress.length == amount.length,"input array length mismatch");
        for(uint index =0; index < tokenAddress.length; index++ ){
        require(isStakingAllowed[tokenAddress[index]],"staking not enabled");
        balances[msg.sender][tokenAddress[index]] += amount[index] ;
        ERC20 token = ERC20(tokenAddress[index]);
        if(token.balanceOf(msg.sender) < amount[index]){
            require(false,'transfer failed due to less balance');
        }
        token.transferFrom(msg.sender, protocols[tokenAddress[index]], amount[index]);

        if(tokenAddress[index] == Push){
            Staking_Standard( protocols[tokenAddress[index]]).deposit(tokenAddress[index],msg.sender, amount[index]);
            emit Deposit(msg.sender, tokenAddress[index], amount[index]);
        } else {
            if(tokenAddress[index] == 0x0595328847AF962F951a4f8F8eE9A3Bf261e4f6b){ // OHM token
                Staking_Standard(protocols[tokenAddress[index]]).deposit(tokenAddress[index],msg.sender, amount[index]);
                emit Deposit(msg.sender, tokenAddress[index], amount[index]);
            }
        }
    }        

    }

    function unStake(address tokenAddress, uint256 amount) public {

        require(isUnstakingAllowed[tokenAddress],"unstaking not enabled");
        require(amount <= balances[msg.sender][tokenAddress],"you can only withdraw your staked amount");
        balances[msg.sender][tokenAddress] -= amount ;

        if(tokenAddress == Push){
            Staking_Standard( protocols[tokenAddress]).withdraw(tokenAddress,msg.sender, amount);
            emit Withdraw(msg.sender, tokenAddress, amount);
        } else {
            if(tokenAddress == 0x0595328847AF962F951a4f8F8eE9A3Bf261e4f6b){ // OHM token
                Staking_Standard(protocols[tokenAddress]).withdraw(tokenAddress,msg.sender, amount);
                emit Withdraw(msg.sender, tokenAddress, amount);
            }
        }
    }

    function autoCompond(address tokenAddress, uint _amount) public {

        if(tokenAddress == Push){
            uint autoAmount = Staking_Standard( protocols[tokenAddress]).autoCompound(tokenAddress, _amount);
            emit AutoCompund(tokenAddress, autoAmount);
        }

    }

    function addProtocols(address token, address protocol) public{
        protocols[token] = protocol;
        isStakingAllowed[token] = true;
        isUnstakingAllowed[token] = true;
        emit ProtocolAdded(token ,  protocol);
    }

    function changeStakeStatus(address _token, bool _stake, bool _unstake) public{
        isStakingAllowed[_token] = _stake;
        isUnstakingAllowed[_token] = _unstake;
    }


}