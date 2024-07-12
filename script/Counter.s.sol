// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Counter.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() external {
        // LOCAL_PRIVATE_KEY PRIVATE_KEY
        uint256 deployerPrivateKey = vm.envUint("LOCAL_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        // vm.startBroadcast();

        Counter c = new Counter();
        console2.log("Counter deployed on %s", address(c));

        vm.stopBroadcast();
    }
}

// source .env
// 0xf1425D05bFb4c7Fa33D8aa2289De18676Aa1B4C5 0xc9b105dd7df027052b31a5b6d63da4159781a5aa
// forge script script/Counter.s.sol --rpc-url goerli --broadcast --verify
// forge verify-contract --chain-id 5 --watch 0xf1425D05bFb4c7Fa33D8aa2289De18676Aa1B4C5 src/Counter.sol:Counter
// 本地部署 先启动 anvil
// forge script script/Counter.s.sol --fork-url localhost --broadcast
