// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/YGIO.sol";

contract YGIOTest is Test {
    YGIO ygio;
    address slip = address(1);

    function setUp() public {
        ygio = new YGIO(slip);
    }

    function testSlippageAccount() public view {
        address slip_ = ygio.getSlippageAccount();
        console.log(slip_);
    }

    function testGetBalance() public view {
        console.log(ygio.balanceOf(address(this)));
    }

    function testFailTransfer() public {
        ygio.transfer(address(0), 0);
    }

    function testCannotTransfer() public {
        vm.expectRevert(bytes("ERC20: transfer to the zero address"));
        ygio.transfer(address(0), 0);
    }
}
