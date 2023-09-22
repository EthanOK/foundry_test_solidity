// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LPToken is ERC20 {
    constructor() ERC20("LPToken", "LP") {
        _mint(msg.sender, 100000 * 1e18);
        _mint(address(1), 10000 * 1e18);
        _mint(address(2), 20000 * 1e18);
        _mint(address(3), 30000 * 1e18);
        _mint(address(4), 40000 * 1e18);
        _mint(address(5), 50000 * 1e18);
    }
}
