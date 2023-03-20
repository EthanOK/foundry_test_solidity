// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/MyERC20.sol";

contract MyERC20Test is Test {
    MyERC20 public myERC20;

    function setUp() public {
        myERC20 = new MyERC20();
    }

    function testName() public {
        console.log(myERC20.name());
        assertEq(myERC20.name(), "MyERC20");
    }

    function testSymbol() public {
        console.log(myERC20.symbol());
        assertEq(myERC20.symbol(), "MEC");
    }

    function testTotalSupply() public {
        console.log(myERC20.totalSupply());
        assertEq(myERC20.totalSupply(), 10000 * 10 ** myERC20.decimals());
    }
}
