// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// 在以太坊上用ERC20 模拟铭文铸造,创建工厂合约:
// • 方法1:deployInscription(string name, string symbol, uint
//  totalSupply, uint perMint), 用户调用该方法实现最小代理的方式创建 ERC20 token
// • 方法 2:mintInscription(address tokenAddr)

contract InsciptionsERC20 is Initializable, IERC20 {
    
}
