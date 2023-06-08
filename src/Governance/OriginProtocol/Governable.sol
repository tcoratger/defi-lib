// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Governable OriginProtocol
// https://github.com/OriginProtocol/nft-launchpad/blob/master/contracts/contracts/governance/Governable.sol
abstract contract Governable {
  // Storage position of the owner and pendingOwner of the contract
  // keccak256("OUSD.governor");
  bytes32 private constant governorPosition = 0x7bea13895fa79d2831e0a9e28edede30099005a50d652d8957cf8a607ee6ca4a;

  // keccak256("OUSD.pending.governor");
  bytes32 private constant pendingGovernorPosition = 0x44c4d30b2eaad5130ad70c3ba6972730566f3e6359ab83e800d905c61b1c51db;

  event PendingGovernorshipTransfer(address indexed previousGovernor, address indexed newGovernor);

  event GovernorshipTransferred(address indexed previousGovernor, address indexed newGovernor);

  /**
   * @dev Initializes the contract setting the deployer as the initial Governor.
   */
  constructor() {
    _setGovernor(msg.sender);
    emit GovernorshipTransferred(address(0), _governor());
  }

  /**
   * @dev Returns the address of the current Governor.
   */
  function governor() public view returns (address) {
    return _governor();
  }

  /**
   * @dev Returns the address of the current Governor.
   */
  function _governor() internal view returns (address governorOut) {
    bytes32 position = governorPosition;
    assembly {
      governorOut := sload(position)
    }
  }

  /**
   * @dev Returns the address of the pending Governor.
   */
  function _pendingGovernor() internal view returns (address pendingGovernor) {
    bytes32 position = pendingGovernorPosition;
    assembly {
      pendingGovernor := sload(position)
    }
  }

  /**
   * @dev Throws if called by any account other than the Governor.
   */
  modifier onlyGovernor() {
    require(isGovernor(), "Caller is not the Governor");
    _;
  }

  /**
   * @dev Returns true if the caller is the current Governor.
   */
  function isGovernor() public view returns (bool) {
    return msg.sender == _governor();
  }

  // Internal function to set final governance
  function _setGovernor(address newGovernor) internal {
    bytes32 position = governorPosition;
    assembly {
      sstore(position, newGovernor)
    }
  }

  // Internal function to set pending governance
  function _setPendingGovernor(address newGovernor) internal {
    bytes32 position = pendingGovernorPosition;
    assembly {
      sstore(position, newGovernor)
    }
  }

  // Governor can transfer pending governance
  // before new governor accepts the situation
  // Missed address 0 verification
  function transferGovernance(address _newGovernor) external onlyGovernor {
    _setPendingGovernor(_newGovernor);
    emit PendingGovernorshipTransfer(_governor(), _newGovernor);
  }

  /**
   * @dev Claim Governance of the contract to a new account (`newGovernor`).
   * Can only be called by the new Governor.
   */
  function claimGovernance() external {
    require(msg.sender == _pendingGovernor(), "Only the pending Governor can complete the claim");
    _changeGovernor(msg.sender);
  }

  /**
   * @dev Change Governance of the contract to a new account (`newGovernor`).
   * @param _newGovernor Address of the new Governor
   */
  function _changeGovernor(address _newGovernor) internal {
    require(_newGovernor != address(0), "New Governor is address(0)");
    emit GovernorshipTransferred(_governor(), _newGovernor);
    _setGovernor(_newGovernor);
  }
}
