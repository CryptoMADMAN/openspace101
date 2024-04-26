// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TokenBankWithCallBack} from "../../src/w2d4/TokenBankWithCallBack.sol";
import {MyERC721} from "../../src/w2d4/NFT.sol";
import {BaseERC20WithCallBack} from "../../src/w2d4/BaseERC20WithCallBack.sol";

contract BaseERC20WithCallBackTest is Test {
    BaseERC20WithCallBack public myToken;
    TokenBankWithCallBack public bank;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address car = makeAddr("car");

    function setUp() public {
        myToken = new BaseERC20WithCallBack("MM", "MM", 10000);
        bank=new TokenBankWithCallBack(address(myToken));

    }

    function test_Transfer() public {
        myToken.transfer(alice,1000);
        assertEq(myToken.balanceOf(alice), 1000);
    }

    function test_Approve() public {
        test_Transfer();
        vm.startPrank(alice);
        myToken.approve(bob, 300);
        assertEq(myToken.allowance(alice,bob), 300);
        vm.stopPrank();
    }

    function test_TransferFrom() public {
        // transferFrom(address _from, address _to, uint256 _value)
        test_Approve();
        vm.startPrank(bob);
        myToken.transferFrom(alice, car, 300);
        vm.stopPrank();
    }

    function  test_transferWithCallBack() public {
        test_Transfer();
        // transfer(address _to, uint256 _value)
        vm.startPrank(alice);
        // transferWithCallBack(address _to, uint256 _value) public returns (bool)
        myToken.transferWithCallBack(bob,100);
        vm.stopPrank();
    }

}
