// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/AccountProxy.sol";

contract DeployAccountProxyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        console.log("Deploying AccountProxy contract...");

        AccountProxy proxy = new AccountProxy(
            0x2FE5ccb0d7Ea195FEb87987d3573F9fcCE2b5D57,
            0x2326aA72fB2227F7C685FE9bC870dDFbE27Aa952
        );
        console.log("AccountProxy deployed at address:", address(proxy));

        vm.stopBroadcast();
    }
}

// forge script script/DeployAccountProxy.s.sol --rpc-url sepolia --broadcast --verify -vvvv
