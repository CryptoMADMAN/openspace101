// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IToken is IERC20 {
    function mint(address to, uint256 amount) external;
}

interface IStaking {
    function stake() external payable;

    function unstake(uint128 amount) external payable;

    function claim() external;

    function balanceOf(address addr) external view returns (uint256);

    function viewRewards(address addr) external view returns (uint256);
}
