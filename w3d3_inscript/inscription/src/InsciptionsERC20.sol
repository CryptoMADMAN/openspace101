// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// 在以太坊上用ERC20 模拟铭文铸造,创建工厂合约:
// • 方法1:deployInscription(string name, string symbol, uint
// totalSupply, uint perMint), 用户调用该方法实现最小代理的方
// 式创建 ERC20 token
// • 方法 2:mintInscription(address tokenAddr)

contract InsciptionsERC20 is Initializable, ERC20 {
    address private _owner;
    uint256 private _numsPerMint;
    uint256 private _supplyCap;

    constructor() {
        // do nothing
        _disableInitializers();
    }

    function initialize(address owner_, string memory symbol_, uint256 supplyCap_, uint256 numsPerMint_)
        public
        initializer
    {
        _numsPerMint = numsPerMint_;
        _supplyCap = supplyCap_;
        _name = "InsciptionsERC20";
        _symbol = symbol_;
        _owner = owner_;
        // 将所有 token 发给 owner
        _balances[owner_] = totalSupply_;
    }

    function mint(address to) public {
        // 检查供应量是否超过上限
        require(totalSupply() + _numsPerMint <= _supplyCap, "supplyCap exceed limit");
        _mint(to, _numsPerMint);
    }
}
