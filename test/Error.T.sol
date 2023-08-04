// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "../src/Error.sol";

contract ErrorTest is Test {
    Error public errorContrat;

    function setUp() public {
        errorContrat = new Error();
    }

    function testFailErrorRevert() public {
        errorContrat.errorRevert();
    }

    function testFailErrorRequire() public {
        errorContrat.errorRequire();
    }

    function testFailErrorAssert() public {
        errorContrat.errorAssert();
    }
}
