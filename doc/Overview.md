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
> Style: bullet points  
> Content: Who-How-What

- ContractOwner creates a vesting schedule for a specific Beneficiary’s wallet address.
- Both ContractOwner and Beneficiary can release the token being vested, and transfer it to Beneficiary wallet.
- ContractOwner can revoke an existing vesting schedule.

### Warning/Note
> Style: emoji + bold
> Contents: Warning and/or Note

🚧 **WARNING:**  
Module doesn't support native token such as Ether on Ethereum network.

🖊️ **NOTE:**  
Module doesn't support native token such as Ether on Ethereum network.


## Use-case

> Style: bullet points  
> Content: from persona

- As a sales manager of your project token:
    1. You create a plan of how to distribute your token regarding to the vesting schedule of this module.
    2. You call out the investors who want to acquire your project token, and collect their wallet address.
    3. 
    4. Module handles token vesting schedule and releasing the accumulated token for each stakeholder(e.g. investor).
    5. Your project token would be bought by investors over an ico/public sale/seed phase over a period of time.

- 

## Sample dApp

> Paste the link of sample dApp repo.
- github repo URL(JCorder works on it)

---
## Review report
- [Norika's report](https://github.com/suricata3838/bunzz-Vesting-module)s