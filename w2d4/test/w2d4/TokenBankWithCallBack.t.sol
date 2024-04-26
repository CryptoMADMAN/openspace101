// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NFTMarketWithCallBack} from "../../src/w2d4/NFTMarketWithCallBack.sol";
import {MyERC721} from "../../src/w2d4/NFT.sol";
import {BaseERC20WithCallBack} from "../../src/w2d4/BaseERC20WithCallBack.sol";
import {TokenBankWithCallBack} from "../../src/w2d4/TokenBankWithCallBack.sol";

contract TokenBankWithCallBackTest is Test {
    BaseERC20WithCallBack public myToken;
    TokenBankWithCallBack public bank;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address car = makeAddr("car");

    /// 运行测试前的执行代码，可用于准备测试的数据的执行
    function setUp() public {
        myToken = new BaseERC20WithCallBack("MM", "MM", 10000);
        bank = new TokenBankWithCallBack(address(myToken));
        myToken.transfer(alice, 100);
    }

    /// 测试如果没有授权NFT,则无法list的成功
    function test_deposit() public {
        // deposit(address _token,uint256 _amount)
        vm.startPrank(alice);
        //  function approve(address _spender, uint256 _value)
        myToken.approve(address(bank), 100);

        bank.deposit(address(myToken), 100);
        vm.stopPrank();

        assertEq(bank.depositBalances(alice,address(myToken))==100, true);
    }

    function test_withdraw() public {
        test_deposit();
        vm.startPrank(alice);
        bank.withdraw(address(myToken),100);
        vm.stopPrank();
        assertEq(myToken.balanceOf(alice)==100, true);
    }

    function test_tokenReceived() public {
        vm.startPrank(alice);
        myToken.transferWithCallBack(address(bank),100);
        vm.stopPrank();
        assertEq(bank.depositBalances(alice,address(myToken))==100, true);

    }
}
