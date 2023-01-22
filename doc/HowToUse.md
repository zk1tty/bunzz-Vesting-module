## Preparation before deployment
1. Deploy your ERC20 token if you won't use existing ERC20 token like USDC.
2. Start selling your tokens in an ICO/public sale/private sale/seed phase round.

## Get started(Operation)
As Project Owner,

1. Deploy Vesting contract.
2. Call the function `connectToOtherContracts()`(link to Function page) to configure the erc20 token to be vested. 
The function takes one argument: an array of addresses. 
The first item of the array will be used.(Why?)
3. Transfer the necessary amount of tokens to the vesting contract.
4. To create a vesting schedule for an investor, call the function `createVesintgSchedule()`(link to Function page). 
<!-- The function has 7 arguments as follows:
    - `_beneficiary`: the address of the investor.
    - `_start`: the start datetime as an unix timestamp.
    - `_cliff`: the pause between the start time and the moment of available withdrawal.
    - `_duration`: the duration of the vesting schedule.
    - `_slicePerSeconds`:  how many tokens will be unlocked every second starting with the startTime.
    - `_revocable`: a boolean that gives the owner the power to revoke the vesting schedule or not. This can only be decided when the vesting schedule is created.
    - `_amount`: the amount of tokens that will be vested. -->
5. To revoke the vesting schedule of the specific investor, call the function `revoke()`(link to Function page). 
This function can only be called by the owner.You can only revoke a vesting schedule that have been marked as revocable at the moment of creation.
<!-- It is having only one argument and that is of type bytes32 and represents the id of the vesting schedule you want to revoke.  -->

As Beneficiary,
1. Call `release()`(link to Function page) function to retrieve the vested tokens. 
This function has 2 arguments as follows.
    - vestingScheduleId: the id of the vesting schedule. <- how to get the ID?
    - amount: the amount of funds you want to retrieve.

## How-to
- how to get the vestingSchedule ID?
  - getVestingSchedulesCountByBeneficiary()?
- how to check the current releasable Amount?