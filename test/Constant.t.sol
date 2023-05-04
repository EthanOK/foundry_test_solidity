// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "../src/Constant.sol";

contract ConstantTest is Test {
    Constant public constantContract;

    function setUp() public {
        constantContract = new Constant();
    }

    function testConstant() public {
        constantContract.varConstant();
    }

    function testImmutable() public {
        constantContract.varImmutable();
    }

    function testVariable() public {
        constantContract.variable();
    }
}
// forge test --match-path test/Constant.t.sol --gas-report
