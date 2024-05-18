// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {TokenBank} from "../src/sign/TokenBank.sol";
import {MyERC20Permit} from "../src/sign/MyERC20Permit.sol";
import {SigUtils} from "../src/sign/SigUtil.sol";

contract TokenBankTest is Test {
    TokenBank public tokenBank;
    MyERC20Permit public token;
    SigUtils public sigUtil;

    function setUp() public {
        token = new MyERC20Permit();
        tokenBank = new TokenBank(address(token));
    }

    function test_permitDeposit() public {
        sigUtil = new SigUtils(token.DOMAIN_SEPARATOR());

        (address alice, uint256 aliceKey) = makeAddrAndKey("alice");

        token.mint(address(this), 100);
        token.transfer(alice, 100);
        vm.startPrank(alice);

        SigUtils.Permit memory permit = SigUtils.Permit({
            owner: alice,
            spender: address(tokenBank),
            value: 100,
            nonce: token.nonces(alice),
            deadline: 1 hours
        });

        bytes32 digest = sigUtil.getTypedDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(aliceKey, digest);

        tokenBank.permitDeposit(100, 1 hours, v, r, s);
    }
}
