// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BaseERC20.sol";

interface IERC20 {
    function balanceOf(address _owner) external  view returns(uint);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) ;

    function transfer(address _to, uint256 _value) external returns (bool success);
}

contract TokenBank {
    // BaseERC20 public token;
    mapping(address => mapping(address=>uint256)) public depositBalances;

    constructor() {
        // token = new BaseERC20();
    }

    function deposit(address _token,uint256 amount) public {

        uint256 balanceBefore = IERC20(_token).balanceOf(address(this));
        bool sent = IERC20(_token).transferFrom(msg.sender, address(this), amount);
        require(sent, "Token transfer failed");
        uint256 balanceAfter = IERC20(_token).balanceOf(address(this));
        uint256 actualAmount = balanceAfter - balanceBefore; // To make sure what is actually received
        depositBalances[msg.sender][_token] += actualAmount;
    }

    function withdraw(address _token,uint256 amount) public {

        require(depositBalances[msg.sender][_token] >= amount, "Insufficient balance");
        depositBalances[msg.sender][_token] -= amount;
        bool sent = IERC20(_token).transfer(msg.sender, amount);
        require(sent, "Token transfer failed");
    }
}
