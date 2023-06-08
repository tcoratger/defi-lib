# OriginProtocol Governable contract

## Purpose of the contract

The objective of the contract is to establish a governance logic with a governor that can be changed through the `transferGovernance` function.
It allows the current governor to temporarily transfer the governance to another address, while waiting for the new governor to claim the governance through the `claimGovernance` function.
