// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "forge-std/Test.sol";

contract VmTest is Test {
    function testFfi() public {
        bytes32 hash = keccak256(abi.encodePacked("hello"));
        // cast keccak256 hello
        string[] memory cmd = new string[](3);
        cmd[0] = "cast";
        cmd[1] = "keccak256";
        cmd[2] = "hello";

        bytes memory result = vm.ffi(cmd);
        bytes32 hash1 = abi.decode(result, (bytes32));

        assertEq(hash1, hash);

        bytes4 selector1 = IERC20.transfer.selector;
        string[] memory cmd1 = new string[](3);
        cmd1[0] = "cast";
        cmd1[1] = "sig";
        cmd1[2] = "transfer(address,uint256)";

        // cast sig "transfer(address,uint256)"
        bytes memory result1 = vm.ffi(cmd1);
        bytes4 selector2 = bytes4(result1);
        assertEq(selector1, selector2);
    }
}
// forge test --match-contract VmTest --ffi -vvvv
