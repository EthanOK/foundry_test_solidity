// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/YGIO.sol";

contract YGIOTest is Test {
    YGIO ygio;
    address slip = address(1);
    address poolLp = address(this);

    function setUp() public {
        ygio = new YGIO(slip);
        ygio.setTxPoolRate(poolLp, 50);
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

    function testTransfer() public {
        uint256 balance = ygio.balanceOf(poolLp);
        address user = address(2);
        console.log(ygio.balanceOf(slip));
        // pool => user remove 0.5%
        ygio.transfer(address(2), balance / 2);

        assertEq(balance / 2 > ygio.balanceOf(user), true);
        console.log(ygio.balanceOf(slip));
        // user => pool remove 0.5%
        vm.prank(user);
        ygio.approve(poolLp, balance);

        ygio.transferFrom(user, poolLp, balance / 4);

        console.log(ygio.balanceOf(slip));
    }
}
