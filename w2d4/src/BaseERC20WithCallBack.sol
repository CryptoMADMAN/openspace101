// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import './BaseERC20.sol';

contract BaseERC20WithCallBack is BaseERC20 {

    constructor(string memory _name, string memory _symbol, uint256 _totalSupply) BaseERC20(_name, _symbol, _totalSupply){

    }

    event ABICALL(bool b);

    function transferWithCallBack(address _to, uint256 _value) public returns (bool){
        bool b = transfer(_to, _value);
        // _to.code.length>0去判断是否_to是否是合约
        if (_to.code.length > 0) {
            // 使用 call 来动态调用 tokensReceived 方法
            (bool success,) = _to.call(abi.encodeWithSignature('tokensReceived(address,uint256)', msg.sender, _value));
            emit ABICALL(success);
        }
        return b;
    }

    function transferWithCallBack(address _to, uint256 _value, bytes memory _data) public returns (bool){
        bool b = transfer(_to, _value);
        if (_to.code.length > 0) {
            // 使用 call 来动态调用 tokensReceived 方法
            (bool success,) = _to.call(abi.encodeWithSignature('tokensReceived(address,uint256,bytes)', msg.sender, _value, _data));
            emit ABICALL(success);
        }
        return b;
    }
}
