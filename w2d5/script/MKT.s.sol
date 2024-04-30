// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import "../src/BaseERC20.sol";
import "../src/BaseERC20WithCallBack.sol";
import "../src/ERC20Mock.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        BaseERC20WithCallBack token20 = new BaseERC20WithCallBack("123", "123", 123);
        console.log("token", address(token20));
        token20.transfer(0x832fb464C8bA34BB7Be951CF18fc4EA4718931df, 10000);
        vm.broadcast();
    }
}
