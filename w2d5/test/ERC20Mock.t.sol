// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ERC20Mock} from "../src/ERC20Mock.sol";
import {Transfer} from "../src/Events.sol";

contract ERC20MockTest is Test {
    ERC20Mock public myToken;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address car = makeAddr("car");

    function setUp() public {
        myToken = new ERC20Mock("MM", "MM");
        myToken.mint(alice, 1000);
    }

    function testTokenTransferEvent() public {
        //  Transfer(alice, bob, 1000);
        //全部匹配
        // vm.expectEmit();
        // emit Transfer(alice, bob, 1000);
        vm.prank(alice);
        myToken.transfer(bob, 1000);
        vm.stopPrank();

        //部分匹配
        vm.expectEmit(true, true, false, false);
        emit Transfer(bob, alice, 5000);
        vm.prank(bob);
        myToken.transfer(alice, 1000);

        // 测试一次call中的多次事件，只需要按事件顺序定义即可
        uint256 times = 1000;
        for (uint256 i = 0; i < times; i++) {
            vm.expectEmit();
            emit Transfer(address(0), bob, 1000);
        }
        myToken.batchMint(bob, 1000, times);
    }
}
