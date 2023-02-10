## About
> Style: 2-3 lines description  
> Content: What issue does this module solve?

Vesting Module attaches vesting schedules to only ERC20 tokens. Vesting schedule controls the timing for stakeholders to acquire the project token.


## Tags
> 5-7 keywords about the contract which will later be used for search.
> Content: use-case in the biz term, technical traits

- (biz use-cases)
    - project-token
    - TGE(token generation event)
    - token-sale
    - token-allocation

- (technical traits)
    - vesting
    - schedule-manager
    - ERC20
    - attach-to-ERC20Token

## Features

> Style: dot bullet  
> Content: Who-How-What

- ContractOwner creates a vesting schedule for a specific Beneficiary’s wallet address.
- Both ContractOwner and Beneficiary can release the token being vested, and transfer it to Beneficiary wallet.
- ContractOwner can revoke an existing vesting schedule.

> 🚧 **WARNING**  
> Contract doesn't support native token such as Ether on Ethereum network.


## Use case

- As a token-sales manager of your project token:
    - This module handles token vesting schedule and token releasing for each stake-holder(e.g. investor).
    - Your project token would be bought by investors over an ico/public sale/seed phase over a period of time that is pre-calculated.

## Sample dApp
- github repo URL

---
## Review report
- [Norika's report](https://github.com/suricata3838/bunzz-Vesting-module)