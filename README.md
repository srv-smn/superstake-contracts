# SuperStake
## Onestop platform for token staking and auto-compounded returns
### Types of interface
	1. Standard staking interface
	2. Protocol related interface
	3. IUser

### Types of contracts:
	1. Super Stake Main contract
	2. Standard Helper contract
	3. User specific unstaking contract

### Core platform functionality
	1. Staking 
	2. Auto-compounding
	3. batching	
	
### Core contract functionality:
	1. Standard protocol interface - Done
	2. Upgradable reusable architecture - Done
	3. Core functionality - In Progress
	4. Openzeppelin upgradablity 
	5. Security/access control
	6. Reducing charges
	7. Gas Optimisation
	8. Gasless 
	
### Superstake main contract
	1. Transfer funds from user EOA to helper contract 
	2. Core contract to interact with helper contract
	3. Keep track of user staking balance/transaction
	4. Keep track of user unstaking/cooldown window
	5. Emit different events based on transaction happening
	6. Deploy userspecific contract wallet
	
### Standard Helper Contract
	1. Interact with the Protocol staking contract
	2. Perform the staking/unstaking/auto-compounding on protocol
	3. Transfer funds to user specific contract wallet
	
### User specific contract
    1. Different contract with access levels

