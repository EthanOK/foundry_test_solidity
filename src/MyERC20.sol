// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyERC20 is ERC20 {
    constructor() ERC20("MyERC20", "MEC") {
        _mint(msg.sender, 10000 * 10 ** decimals());
    }
}
