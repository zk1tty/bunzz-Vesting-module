pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IVesting.sol";
import "../bunzz/IBunzz.sol";
import "./VestingStorage.sol";

contract Vesting is Ownable, ReentrancyGuard, VestingStorage, IVesting{
    using SafeERC20 for IERC20;
  
    modifier onlyIfVestingScheduleNotRevoked(bytes32 vestingScheduleId) {
        require(vestingSchedules[vestingScheduleId].initialized == true, "Vesting: Id is not initialized");
        require(vestingSchedules[vestingScheduleId].revoked == false, "Vesting: vesting schedule already revoked");
        _;
    }
   
    function connectToOtherContracts(address[] calldata contracts) external onlyOwner{
        require(contracts[0] != address(0),"Vesting: Token address is zeroAddress");
        _token = contracts[0];
    }

    function getVestingSchedulesCountByBeneficiary(address _beneficiary) external override view returns(uint256){
        return holdersVestingCount[_beneficiary];
    }

  
    function getVestingIdAtIndex(uint256 index) external override view returns(bytes32){
        require(index < getVestingSchedulesCount(), "Vesting: index out of bounds");
        return vestingSchedulesIds[index];
    }

   
    function getVestingScheduleByAddressAndIndex(address holder, uint256 index) external view returns(VestingSchedule memory){
        return getVestingSchedule(computeVestingScheduleIdForAddressAndIndex(holder, index));
    }



    function getVestingSchedulesTotalAmount() external view override returns(uint256){
        return vestingSchedulesTotalAmount;
    }

  
    function getToken() external override view returns(address){
        return address(_token);
    }

   
    function createVestingSchedule(
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration,
        uint256 _slicePeriodSeconds,
        bool _revocable,
        uint256 _amount
    ) external override onlyOwner{
        require(
            getWithdrawableAmount() >= _amount,
            "Vesting: cannot create vesting schedule because not sufficient tokens"
        );
        require(_duration > 0, "Vesting: duration must be > 0");
        require(_amount > 0, "Vesting: amount must be > 0");
        require(_slicePeriodSeconds >= 1, "Vesting: slicePeriodSeconds must be >= 1");
        bytes32 vestingScheduleId = computeNextVestingScheduleIdForHolder(_beneficiary);
        uint256 cliff = _start + _cliff;
        vestingSchedules[vestingScheduleId] = VestingSchedule(
            _beneficiary,
            cliff,
            _start,
            _duration,
            _slicePeriodSeconds,
            _amount,
            0,            
            true,
            _revocable,
            false
        );
        vestingSchedulesTotalAmount = vestingSchedulesTotalAmount + _amount;
        vestingSchedulesIds.push(vestingScheduleId);
        uint256 currentVestingCount = holdersVestingCount[_beneficiary];
        holdersVestingCount[_beneficiary] = currentVestingCount + 1;
    }

  

    function revoke(bytes32 vestingScheduleId) external override onlyOwner onlyIfVestingScheduleNotRevoked(vestingScheduleId){
        VestingSchedule storage vestingSchedule = vestingSchedules[vestingScheduleId];
        require(vestingSchedule.revocable == true, "Vesting: vesting is not revocable");
        uint256 vestedAmount = _computeReleasableAmount(vestingSchedule);
        if(vestedAmount > 0){
            release(vestingScheduleId, vestedAmount);
        }
        uint256 unreleased = vestingSchedule.amountTotal - vestingSchedule.released;
        vestingSchedulesTotalAmount = vestingSchedulesTotalAmount - unreleased;
        vestingSchedule.revoked = true;
    }

 
    function withdraw(uint256 amount) external override nonReentrant onlyOwner{
        require(getWithdrawableAmount() >= amount, "Vesting: not enough withdrawable funds");

        getTokenObj().safeTransfer(owner(), amount);
    }


    function release(
        bytes32 vestingScheduleId,
        uint256 amount
    ) public override nonReentrant onlyIfVestingScheduleNotRevoked(vestingScheduleId) {
        VestingSchedule storage vestingSchedule = vestingSchedules[vestingScheduleId];
        bool isBeneficiary = false; 
        if(msg.sender == vestingSchedule.beneficiary){
            isBeneficiary=true;
        }
        bool isOwner = false; 
        if(msg.sender == owner()){
            isOwner=true;
        }
        require(
            isBeneficiary==true || isOwner==true,
            "Vesting: only beneficiary and owner can release vested tokens"
        );
        uint256 vestedAmount = _computeReleasableAmount(vestingSchedule);
        require(vestedAmount >= amount, "Vesting: cannot release tokens, not enough vested tokens");
        vestingSchedule.released = vestingSchedule.released + amount;
        vestingSchedulesTotalAmount = vestingSchedulesTotalAmount - amount;
        getTokenObj().safeTransfer(vestingSchedule.beneficiary, amount);
    }

 
    function getVestingSchedulesCount() public override view returns(uint256){
        return vestingSchedulesIds.length;
    }


    function computeReleasableAmount(bytes32 vestingScheduleId) public override onlyIfVestingScheduleNotRevoked(vestingScheduleId) view returns(uint256){
        VestingSchedule storage vestingSchedule = vestingSchedules[vestingScheduleId];
        return _computeReleasableAmount(vestingSchedule);
    }

  
    function getVestingSchedule(bytes32 vestingScheduleId) public view returns(VestingSchedule memory){
        return vestingSchedules[vestingScheduleId];
    }


    function getWithdrawableAmount() public override view returns(uint256){
        return getTokenObj().balanceOf(address(this)) - vestingSchedulesTotalAmount;
    }


    function computeNextVestingScheduleIdForHolder(address holder) public override view returns(bytes32){
        return computeVestingScheduleIdForAddressAndIndex(holder, holdersVestingCount[holder]);
    }

 
    function getLastVestingScheduleForHolder(address holder) public view returns(VestingSchedule memory){
        return vestingSchedules[computeVestingScheduleIdForAddressAndIndex(holder, holdersVestingCount[holder] - 1)];
    }

   
    function computeVestingScheduleIdForAddressAndIndex(address holder, uint256 index) public override pure returns(bytes32){
        return keccak256(abi.encodePacked(holder, index));
    }

   
    function _computeReleasableAmount(VestingSchedule memory vestingSchedule) internal view returns(uint256){
        uint256 currentTime = getCurrentTime();
        if ((currentTime < vestingSchedule.cliff) || vestingSchedule.revoked == true) {
            return 0;
        } else if (currentTime >= vestingSchedule.start + vestingSchedule.duration) {
            return vestingSchedule.amountTotal - (vestingSchedule.released);
        } else {
            uint256 timeFromStart = currentTime - (vestingSchedule.start);
            uint secondsPerSlice = vestingSchedule.slicePeriodSeconds;
            uint256 vestedSlicePeriods = timeFromStart / (secondsPerSlice);
            uint256 vestedSeconds = vestedSlicePeriods * (secondsPerSlice);
            // CAUTION
            // originally, it's "vestedAmount = vestingSchedule.amountTotal * (vestedSeconds / vestingSchedule.duration)".
            // But it was deformed to avoid a decimal calculation.
            uint256 vestedAmount = (vestingSchedule.amountTotal * vestedSeconds) / vestingSchedule.duration;
            vestedAmount = vestedAmount - vestingSchedule.released;
            return vestedAmount;
        }
    }

    function getTokenObj() internal view returns(IERC20) {
        IERC20 token = IERC20(_token);
        return token;
    }

    function getCurrentTime() internal virtual view returns(uint256){
        return block.timestamp;
    }

}