# Operational Process
The owner needs to set up the following items:

|Name|Type|Description|Example|Default|
|--- |---|---|---|---|
|token|address|The address of the token that will be vested|[0x690b9a9e9aa1c9db991c7721a92d351db4fac990]|NO|

<!--- Case: Actor is Project Owner --->
1. Deploy your ERC20 token. Or any ERC20 token.
2. Sell your tokens in an ICO/public sale/private sale/seed phase round.
3. Call the function `connectToOtherContracts` to set up the details explained in the table from above. 
The function takes only one argument that represents an array of addresses. 
The first item of the array represents the erc20 token that will be vested.
4. Transfer the necessary amount of tokens to the vesting contract.
5. To create a vesting schedule for an investor, call the function [createVesintgSchedule](https://app.bunzz.dev/module-templates/0727405d-57f6-4cd1-be66-6667a96227e2/functions#createVesintgSchedule). 
The function has 7 arguments. 
They will be enumerated and shortly explained in the following order: _beneficiary, _start, _cliff, _duration, _slicePerSecond, _revocable, _amount.
  - `_beneficiary` represents the address of the investor.
  - `_start` represents the start datetime as an unix timestamp.
  - `_cliff` represents the pause between the start time and the moment of available withdrawal.
  - `_duration` represent the duration of the vesting schedule.
  - `_slicePerSeconds` represents how many tokens will be unlocked every second starting with the startTime.
  - `_revocable` represent a boolean that gives the owner the power to revoke the vesting schedule or not. This can only be decided when the vesting schedule is created.
  - `_amount` represents the amount of tokens that will be vested.
6. To revoke a vesting schedule from an investor, call the function [revoke](https://app.bunzz.dev/module-templates/0727405d-57f6-4cd1-be66-6667a96227e2/functions#revoke). 
This function can only be called by the owner.
It is having only one argument and that is of type bytes32 and represents the id of the vesting schedule you want to revoke. 
<!--- Q: How to get the Id of vesting schedule? -->
You can only revoke a vesting schedule that have been marked as revocable at the moment of creation.


<!--- Case: Actor is Investor --->
1. To retrieve some of the tokens that have been released for the investor, the investor can call the function “release”. 
This function have 2 arguments, first being vestingScheduleId and represents the id of the vesting schedule from where you want to retrieve funds and the second argument represents the amount of funds you want to retrieve. You want to retrieve a maximum amounts of funds that have been unlocked for you until the moment of calling.