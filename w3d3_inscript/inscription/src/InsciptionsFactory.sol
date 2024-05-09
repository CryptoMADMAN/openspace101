// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/proxy/Proxy.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./InsciptionsERC20.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "./InsciptionsERC20.sol";

// 在以太坊上⽤ ERC20 模拟铭⽂铸造，编写一个可以通过最⼩代理来创建ERC20 的⼯⼚合约，⼯⼚合约包含两个方法：
// - deployInscription(string symbol, uint totalSupply, uint perMint, uint price), ⽤户调⽤该⽅法创建 ERC20 Token合约，
//symbol 表示新创建代币的代号（ ERC20 代币名字可以使用固定的），totalSupply 表示总发行量， perMint 表示单次的创建量， price 表示每个代币铸造时需要的费用（wei 计价）。每次铸造费用在扣除手续费后（手续费请自定义）由调用该方法的用户收取。
// - mintInscription(address tokenAddr) payable: 每次调用发行创建时确定的 perMint 数量的 token，并收取相应的费用。
contract InsciptionsProxyFactory {
    address public _impl;
    address payable _onwer;
    uint256 public constant FIX_FEE = 10;
    mapping(address => _insciption) public _insciptions;

    constructor() {
        _impl = _impl(new InsciptionsERC20());
        _onwer = msg.sender;
    }

    function deployInscription(string memory symbol_, uint256 supplyCap_, uint256 numsPerMint_, uint256 price_)
        public
        returns (address clone)
    {
        address clone = Clones.clone(_impl);
        InsciptionsERC20(clone).initialize(msg.sender, symbol_, supplyCap_, numsPerMint_);
        Insciption insciption = Insciption(msg.sender, symbol_, supplyCap_, numsPerMint_, clone, price_);
        _insciptions[clone] = insciption;
    }

    function mintInscription(address token) {
        require(msg.value = _insciptions[token].numsPerMint * _insciptions[token].price);

        //mint
        InsciptionsERC20(token).mint(msg.sender);
        // pay to deployer and factory

        payable(_insciptions[token].owner).transfer(msg.value * FIX_FEE / 100);
        payable(_onwer).transfer(msg.value * (1 - FIX_FEE / 100));
    }

    struct Insciption {
        address owner; //in fact, deployer
        string symbol;
        uint256 supplyCap;
        uint256 numsPerMint;
        //
        address token;
        uint256 price;
    }
}
