// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract Storage is Ownable {
    uint256 number;

    function setNumber(uint256 num) public onlyOwner {
        number = num;
    }

    function getNumber() public view returns (uint256) {
        return number;
    }
}
