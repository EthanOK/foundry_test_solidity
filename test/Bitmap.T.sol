// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "forge-std/Test.sol";
import "../src/Bitmap.sol";
import "forge-std/console.sol";

contract BitmapTest is Test {
    Bitmap public bitmap;

    function setUp() public {
        bitmap = new Bitmap();
        bitmap.setDataWithBoolArray(
            [true, false, true, false, true, false, true, false]
        );
        bitmap.setDataWithBitmap(170);
    }

    function testSetDataWithBoolArray() public {
        bitmap.setDataWithBoolArray(
            [true, false, true, false, true, false, true, false]
        );
    }

    function testSetDataWithBitmap() public {
        // 10101010
        bitmap.setDataWithBitmap(170);
    }

    function testReadWithBoolArray() public {
        // 从
        bool result = bitmap.readWithBoolArray(1);
        console.log(result);
    }

    function testReadWithBitmap() public {
        // indexFromRight 10101010
        bool result = bitmap.readWithBitmap(1);
        console.log(result);
    }

    function testReadWithBitmapFromLeft() public {
        // indexFromLeft 10101010
        bool result = bitmap.readWithBitmapFromLeft(1);
        console.log(result);
    }
}
// forge test --match-contract BitmapTest -vv
