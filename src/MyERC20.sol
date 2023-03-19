// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {}
}
