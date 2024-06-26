// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Mock is ERC20 {
    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function batchMint(address to, uint256 amount, uint256 times) public {
        for (uint256 i = 0; i < times; i++) {
            _mint(to, amount); // from:address(0) -> to -> amount
        }
    }
}
