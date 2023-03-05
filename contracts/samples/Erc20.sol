// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Erc20 is ERC20 {
    constructor(uint256 _totalSupply) ERC20("Erc20", "ERC20") {
        _mint(msg.sender, _totalSupply);
    }
}
