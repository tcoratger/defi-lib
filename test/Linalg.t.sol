// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/linear_algebra/Linalg.sol";

contract LinalgTest is Test {
  uint[] public a;
  uint[] public b;

  function setUp() public {}

  function testDot1d() public {
    a = [1, 2, 3, 4, 5];
    b = [2, 4, 56, 2, 1];

    assertEq(Linalg.dot1d(a, b), 191);
  }

  function testDot1dDimensionsDontMatch() public {
    a = [1, 2, 3, 4, 5];
    b = [2, 4, 56, 2];

    vm.expectRevert("Linalg: array dimensions don't match");
    Linalg.dot1d(a, b);
  }

  function testDot1dOverflow() public {
    a = [1, 2, 3, 4, type(uint256).max];
    b = [2, 4, 56, 2, 1];

    vm.expectRevert();
    Linalg.dot1d(a, b);
  }

  function testDot1dEmpty() public {
    assertEq(Linalg.dot1d(a, b), 0);
  }
}
