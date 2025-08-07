// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {GelatoChecker} from "../src/gelato/GelatoChecker.sol";

contract GelatoCheckerScript is Script {
    GelatoChecker public gelatoChecker;

    function setUp() public {}

    function run() public {
        // vm.startBroadcast();

        uint256 deployerPrivateKey = vm.envUint("SEPOLIA_PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address[] memory tokens = new address[](2);
        tokens[0] = 0x1d1d95791Dcc3fa1714Be0c8D81B81b6e84B3C14;
        tokens[1] = 0x089a4a03c18fabcf5a6483216f82429279F840a1;

        gelatoChecker = new GelatoChecker(tokens);

        vm.stopBroadcast();
    }
}

// forge script script/GelatoChecker.s.sol --rpc-url sepolia --broadcast --verify
