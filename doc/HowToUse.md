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

## How to call contract methods from Bunzz App

- Get the vestingSchedule ID?
  1. Call `getVestingSchedulesCountByBeneficiary(address beneficiary)`. It returns vestingSchedulesCount which represents how many vestingSchedule the given beneficiary has.
  2. Call `getVestingScheduleByAddressAndIndex(address holder, uint256 index)`. It returns vestingScheduleId(bytes32).

- How to check the detail of vestingSchedule?
  1. Get vestingSchedule ID.
  2. Call `getVestingSchedule(bytes32 vestingScheduleId)`.

- Check the current releasable amount?
  1. Get vestingSchedule ID.
  2. Call `computeReleasableAmount(vestingScheduleId)`

- Get the current block time?
  - Call `getCurrentTime()`


## How to implement methods in FE/BE
---sample code----

```
import { ethers } from "hardhat"
import { keccak256 } from "@ethersproject/keccak256"
import { MerkleTree } from "merkletreejs"

const ONE_WEEK = 60 * 60 * 24 * 7

// Same whitelist as previous example
const whitelist = [
    ["0x08C8e533722578834BC844413d3B11e834f1e36f", "0x2b221d0aFB3309b7E7A6e61a24eFd4B12Adc1038"],
    [ethers.utils.parseEther("5000"), ethers.utils.parseEther("9000")],
    [ONE_WEEK, ONE_WEEK]
]
const nodeLeaves = []

// convert amount to wei
whitelist[1] = whitelist[1].map(amount => ethers.utils.parseEther(val))
for (let i = 0; i < whitelist[0].length; i++) {
    nodeLeaves.push(ethers.utils.solidityKeccack256(
        ["address", "uint256", "uint256"],
        [whitelist[0][i], whitelist[1][i], whitelist[2][i]]
    ))
}

// Generate the merkle tree
const merkleTree = new MerkleTree(nodeLeaves, keccak256, { sortPairs: true })

/**
 * proof[0] is the hash proof for alice
 * proof[1] is the hash proof for bob
 * If any params are given wrong will throw "MerkleVesting: invalid proof" error
 */
const proof = nodeLeaves.map(leaf => merkleTree.getHexProof(leaf))

// @note: You can also delegate to whitelist for other users
await merkleVestingInstance.whitelist(
    whitelist[0][0],
    whitelist[1][0],
    whitelist[2][0],
    proof[0]
)
```