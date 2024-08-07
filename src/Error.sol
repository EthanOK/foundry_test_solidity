// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Error {
    error NotOwner();
    error InvalidSignature();
    error InvalidInput();
    error InvalidState();

    function errorRevert() external pure {
        if (true) revert NotOwner();
    }

    function errorRequire() external pure {
        require(false, "NotOwner");
    }

    function errorAssert() external pure {
        if (true) assert(false);
    }
}
