// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/NFT.sol";

contract MyScript is Script {
    function run() external {
        // LOCAL_PRIVATE_KEY PRIVATE_KEY
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // NFT nft = new NFT("TUT", "TUT");
        // console2.log("NFT deployed on %s", address(nft));

        vm.stopBroadcast();
    }
}
// forge script script/NFT.s.sol --rpc-url sepolia --broadcast --verify -vvvv
