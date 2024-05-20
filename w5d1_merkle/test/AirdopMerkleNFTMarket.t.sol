// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {AirdopMerkleNFTMarket} from "../src/AirdopMerkleNFTMarket.sol";
import {MyERC721} from "../src/copy/MyERC721.sol";
import {MyERC20Permit} from "../src/copy/MyERC20Permit.sol";
import {SigUtils} from "../src/copy/SigUtil.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AirdopMerkleNFTMarketTest is Test {
    MyERC721 nft;
    MyERC20Permit token;
    AirdopMerkleNFTMarket public market;
    SigUtils sigUtil;
    address admin;
    uint256 adminKey;
    address alice;

    function setUp() public {
        adminKey = vm.envUint("ADMIN_KEY");
        admin = vm.envAddress("ADMIN_ADDRESS");
        console.log(adminKey);

        token = new MyERC20Permit();
        nft = new MyERC721();
        token.mint(admin, 100);
        market = new AirdopMerkleNFTMarket(
            address(token),
            address(nft),
            0xbab12079dc0e1f375a00d60f6df333c67d20ac55daca0bfe2027244014be7ab3
        );

        sigUtil = new SigUtils(token.DOMAIN_SEPARATOR());

        alice = makeAddr("alice");

        vm.startPrank(alice);
        nft.mint(alice, "");
        nft.approve(address(market), 1);

        market.list(1, 100);

        vm.startPrank(admin);
    }

    function test_permitPreBuy() public {
        SigUtils.Permit memory permit = SigUtils.Permit({
            owner: admin,
            spender: address(market),
            value: 50,
            nonce: token.nonces(msg.sender),
            deadline: 1 hours
        });

        bytes32 digest = sigUtil.getTypedDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(adminKey, digest);
        market.permitPreBuy(50, 1 hours, v, r, s);
        assertEq(token.allowance(admin, address(market)), 50);
    }

    // Root1: bab12079dc0e1f375a00d60f6df333c67d20ac55daca0bfe2027244014be7ab3
    // Proof1: [
    //   '6abcad1b97d6f11299e4f262963fa5e0265362772642a24d54f0ca24907a9d58',
    //   'be21de36aac606f3b21ad580080c24cc7713a7dd854adbe16b3535bfeeda744a',
    //   '771602f439e0ae89de9c79a85c7641107049b2f15fdd1486f537726ea2b29c63'
    // ]
    // Is valid proof1: true
    function test_claimNFT() public {
        test_permitPreBuy();
        bytes32[] memory proof = new bytes32[](3);
        proof[
            0
        ] = 0x6abcad1b97d6f11299e4f262963fa5e0265362772642a24d54f0ca24907a9d58;
        proof[
            1
        ] = 0xbe21de36aac606f3b21ad580080c24cc7713a7dd854adbe16b3535bfeeda744a;
        proof[
            2
        ] = 0x771602f439e0ae89de9c79a85c7641107049b2f15fdd1486f537726ea2b29c63;
        market.claimNFT(50, 1, proof);
        assertEq(nft.ownerOf(1), admin);
    }

    function test_multicall() public {
        bytes[] memory datas = new bytes[](2);

        //copy
        SigUtils.Permit memory permit = SigUtils.Permit({
            owner: admin,
            spender: address(market),
            value: 50,
            nonce: token.nonces(msg.sender),
            deadline: 1 hours
        });
        bytes32 digest = sigUtil.getTypedDataHash(permit);
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(adminKey, digest);
        datas[0]=abi.encodeWithSelector(market.permitPreBuy.selector, 50, 1 hours, v, r, s);

        bytes32[] memory proof = new bytes32[](3);
        proof[
            0
        ] = 0x6abcad1b97d6f11299e4f262963fa5e0265362772642a24d54f0ca24907a9d58;
        proof[
            1
        ] = 0xbe21de36aac606f3b21ad580080c24cc7713a7dd854adbe16b3535bfeeda744a;
        proof[
            2
        ] = 0x771602f439e0ae89de9c79a85c7641107049b2f15fdd1486f537726ea2b29c63;
        datas[1]=abi.encodeWithSelector(market.claimNFT.selector, 50, 1, proof);
        market.multicall(datas)
        ;
        assertEq(nft.ownerOf(1), admin);
    }
}
