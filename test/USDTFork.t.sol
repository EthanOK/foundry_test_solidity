// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "forge-std/Test.sol";

contract USDTForkTest is Test {
    using SafeERC20 for IERC20;
    IERC20 usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
    address alice;
    address bob = address(0x22);

    function setUp() external {
        // 配置 fork url; ETH_RPC_URL 为 .env 文件中的环境变量
        uint256 forkId = vm.createFork(vm.envString("ETH_RPC_URL"));
        vm.selectFork(forkId);

        alice = address(0x11);
        uint256 before_ = usdt.totalSupply();
        deal(address(usdt), alice, 10000e6);
        uint256 after_ = usdt.totalSupply();
        assertEq(before_, after_);
    }

    function testBalanceOf() external {
        assertEq(usdt.balanceOf(alice), 10000e6);
    }

    function testTransfer() external {
        vm.startPrank(alice);
        usdt.safeTransfer(bob, 20e6);
        assertEq(usdt.balanceOf(bob), 20e6);
        vm.stopPrank();
    }
}

// forge test -vvv --match-contract USDTForkTest --fork-url mainnet --block-number 2028232
// 如果配置了 selectFork: forge test -vvv --match-contract USDTForkTest
