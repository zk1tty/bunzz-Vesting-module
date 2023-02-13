pragma solidity ^0.8.0;

contract VestingStorage {

    /**
     * @dev
     * TODO: should add the descriptin of "when" and "for which purpose" the event will be emitted.
     * TODO: mention the use-case as follows.
     * e.g. vestingSchedulesId is the identifier of vestingSchedule.
     * beneficiary/owner needs to know the vestingSchedulesId to release the amount accumulated for the beneficiary.
     */
    event VestingScheduleCreated(bytes32 vestingSchedulesId);
    
    struct VestingSchedule{
        address  beneficiary;
        uint256  cliff;
        uint256  start;
        uint256  duration;
        uint256 slicePeriodSeconds;
        uint256 amountTotal;
        uint256  released;
        bool initialized;
        bool  revocable;
        bool revoked;
    }

    address internal _token;

    bytes32[] internal vestingSchedulesIds;

    uint256 internal vestingSchedulesTotalAmount;

    mapping(address => uint256) internal holdersVestingCount;
    
    mapping(bytes32 => VestingSchedule) internal vestingSchedules;

    event Released(uint256 amount);
    event Revoked();

}