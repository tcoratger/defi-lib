// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library Linalg {
  function dot1d(uint[] memory a, uint[] memory b) internal pure returns (uint) {
    require(a.length == b.length, "Linalg: array dimensions don't match");

    uint result;

    assembly {
      let ptrA := add(a, 0x20)
      let ptrB := add(b, 0x20)

      for {
        let i := 0
      } lt(i, mload(a)) {
        i := add(i, 1)
      } {
        let addResult := add(result, mul(mload(ptrA), mload(ptrB)))

        if slt(addResult, result) {
          revert(0, 0)
        }

        result := addResult

        ptrA := add(ptrA, 0x20)
        ptrB := add(ptrB, 0x20)
      }
    }

    return result;
  }
}
