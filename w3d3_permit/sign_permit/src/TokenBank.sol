// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol";

contract TokenBank {
    // BaseERC20 public token;
    mapping(address => mapping(address => uint256)) public depositBalances;
    address public _token;

    constructor(address addr_) {
        _token = addr_;
    }

    function permitDeposit(
        address owner_,
        address spender_,
        uint256 amount_,
        uint256 deadline_,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        IERC20Permit(_token).permit(owner_, spender_, amount_, deadline_, v, r, s);
        deposit(amount_);
    }

    function deposit(uint256 amount_) public {
        uint256 balanceBefore = IERC20(_token).balanceOf(address(this));
        bool sent = IERC20(_token).transferFrom(msg.sender, address(this), amount_);
        require(sent, "Token transfer failed");
        uint256 balanceAfter = IERC20(_token).balanceOf(address(this));
        uint256 actualAmount = balanceAfter - balanceBefore; // To make sure what is actually received
        depositBalances[msg.sender][_token] += actualAmount;
    }

    function withdraw(uint256 amount_) public {
        require(depositBalances[msg.sender][_token] >= amount_, "Insufficient balance");
        depositBalances[msg.sender][_token] -= amount_;
        bool sent = IERC20(_token).transfer(msg.sender, amount_);
        require(sent, "Token transfer failed");
    }
}
