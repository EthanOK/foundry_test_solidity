// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface TriggerUpdate {
    function triggerUpdate() external;
}

interface IGelatoChecker {
    function checker()
        external
        view
        returns (bool canExec, bytes memory execPayload);
}

contract GelatoChecker is IGelatoChecker, TriggerUpdate, Ownable {
    address[] public tokens;
    uint256 public lastExecuted;

    constructor(address[] memory _tokens) {
        tokens = _tokens;
    }

    function getTokens() external view returns (address[] memory, uint256) {
        return (tokens, tokens.length);
    }

    function addTokens(address[] calldata _tokens) external onlyOwner {
        for (uint256 i = 0; i < _tokens.length; i++) {
            tokens.push(_tokens[i]);
        }
    }

    function removeToken(address[] calldata _tokens) external onlyOwner {
        for (uint256 i = 0; i < _tokens.length; i++) {
            for (uint256 j = 0; j < tokens.length; j++) {
                if (tokens[j] == _tokens[i]) {
                    tokens[j] = tokens[tokens.length - 1];
                    tokens.pop();
                }
            }
        }
    }

    function checker()
        external
        view
        returns (bool canExec, bytes memory execPayload)
    {
        canExec = (block.timestamp - lastExecuted) > 60;

        execPayload = abi.encodeCall(this.triggerUpdate, ());
    }

    function triggerUpdate() external {
        for (uint i = 0; i < tokens.length; i++) {
            TriggerUpdate(tokens[i]).triggerUpdate();
        }
        lastExecuted = block.timestamp;
    }
}
