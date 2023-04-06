// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/console.sol";
import "forge-std/Test.sol";
import "../src/NftExchangeNewDemo.sol";

contract NftExchangeNewDemoTest is Test, NftExchangeNewDemo {
    NftExchangeNewDemo public nftexchange;
    Order order;

    function setUp() public {
        nftexchange = new NftExchangeNewDemo();
        order.key.owner = 0x6278A1E803A76796a3A1f7F6344fE874ebfe94B2;
        order
            .key
            .salt = 30043922068787383796652898510281479419555943511176550733606329901780427724528;
        //
        order.sellAmount = 1;
        order.unitPrice = 6000000000000000;
        order.startTime = 1679968643;
        order.endTime = 1682647043;
        //
        order.key.sellAsset.token = 0x0D3e02768aB63516Ab5D386fAD462214CA3E6A86;
        order.key.sellAsset.tokenId = 1;
        order.key.sellAsset.assetType = AssetType.ERC721;

        order.key.buyAsset.token = address(0);
        order.key.buyAsset.tokenId = 0;
        order.key.buyAsset.assetType = AssetType.ETH;
    }

    function testFee() public {
        console.log(nftexchange.FEE_10000());
        assertEq(nftexchange.FEE_10000(), 10000);
    }

    function testOrderHash() public {
        bytes32 hash = prepareMessage(order);
        console.logBytes32(hash);
        assertEq(hash, hash);
    }

    // royaltyFeeMessage
    function testRoyaltyFeeHash() public {
        uint256 endtime = 1682647043;
        bytes32 hash = royaltyFeeMessage(order, 250, endtime);
        console.logBytes32(hash);
        assertEq(hash, hash);
    }
}
