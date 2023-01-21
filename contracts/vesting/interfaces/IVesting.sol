pragma solidity ^0.8.0;

interface IVesting {


    function getVestingSchedulesCountByBeneficiary(address _beneficiary) external view returns(uint256);

  
    function getVestingIdAtIndex(uint256 index) external view returns(bytes32);



    function getVestingSchedulesTotalAmount() external view returns(uint256);

  
    function getToken() external view returns(address);

   
    function createVestingSchedule(
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration,
        uint256 _slicePeriodSeconds,
        bool _revocable,
        uint256 _amount
    ) external;

  

    function revoke(bytes32 vestingScheduleId) external;

 
    function withdraw(uint256 amount) external;


    function release(bytes32 vestingScheduleId, uint256 amount) external;

 
    function getVestingSchedulesCount() external view returns(uint256);


    function computeReleasableAmount(bytes32 vestingScheduleId) external  view returns(uint256);

    function getWithdrawableAmount() external view returns(uint256);


    function computeNextVestingScheduleIdForHolder(address holder) external view returns(bytes32);

 
    function computeVestingScheduleIdForAddressAndIndex(address holder, uint256 index) external pure returns(bytes32);


}