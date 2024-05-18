// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";

import {My721Contract} from "../src/eip712demo/My712Contract.sol";

contract My712ContractTest is Test {
    My721Contract myContract;
    address user;
    uint256 userPrivateKey;
    uint256 chainId;

    struct MyMessage {
        address user;
        uint256 amount;
        uint256 nonce;
    }

    function setUp() public {
        myContract = new My721Contract();
        userPrivateKey = 0xA11CE; // Example private key for signing
        user = vm.addr(userPrivateKey);
        chainId = block.chainid;
    }

    function testVerifySignature() public {
        uint256 nonce = myContract.getNonce(user);
        MyMessage memory message = MyMessage(user, 100, nonce);

        bytes32 structHash = keccak256(
            abi.encode(
                keccak256("MyMessage(address user,uint256 amount,uint256 nonce)"),
                message.user,
                message.amount,
                message.nonce
            )
        );

        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", myContract.getDomainSeparator(), structHash));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        bool isValid = myContract.verifySignature(message.user, message.amount, signature);
        assertTrue(isValid);
    }

    function testExecuteTransaction() public {
        uint256 nonce = myContract.getNonce(user);
        MyMessage memory message = MyMessage(user, 100, nonce);

        bytes32 structHash = keccak256(
            abi.encode(
                keccak256("MyMessage(address user,uint256 amount,uint256 nonce)"),
                message.user,
                message.amount,
                message.nonce
            )
        );

        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", myContract.getDomainSeparator(), structHash));

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivateKey, digest);
        bytes memory signature = abi.encodePacked(r, s, v);

        myContract.executeTransaction(message.user, message.amount, signature);

        uint256 newNonce = myContract.getNonce(user);
        assertEq(newNonce, nonce + 1);
    }
}
