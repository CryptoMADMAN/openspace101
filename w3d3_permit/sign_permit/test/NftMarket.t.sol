// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {NFTMarket} from "../src/sign/NFTMarketPermit.sol";
import {MyERC20Permit} from "../src/sign/MyERC20Permit.sol";
import {SigUtils} from "../src/sign/SigUtil.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract MyERC721 is ERC721 {
    uint256 count = 0;

    constructor() ERC721("mynft", "mynft") {}

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    function mint() public {
        _mint(msg.sender, count++);
    }

    // function ownerOf(tokenId){

    // }
}

contract NFTMarketTest is Test {
    NFTMarket public nftMarket;
    MyERC721 public nft;
    MyERC20Permit public token;
    address admin;
    uint256 adminKey;

    function setUp() public {
        (admin, adminKey) = makeAddrAndKey("admin");
        vm.startPrank(admin);
        token = new MyERC20Permit();
        token.mint(admin, 10000);
        nft = new MyERC721();
        nftMarket = new NFTMarket(address(token), address(nft));
        vm.stopPrank();
    }

    function test_permitBuy() public {
        nft.mint();
        nft.approve(address(nftMarket), 0);
        nftMarket.list(0, 100);

        vm.startPrank(admin);

        address alice = makeAddr("alice");
        token.transfer(alice, 100);
        assertEq(token.balanceOf(alice), 100);



        
        bytes32 hash = keccak256(abi.encodePacked(alice, uint256(0)));
        hash = MessageHashUtils.toEthSignedMessageHash(hash);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(adminKey, hash);
        bytes memory sig = abi.encodePacked(r, s, v);
        vm.stopPrank();

        vm.startPrank(alice);
        token.approve(address(nftMarket), 100);
        nftMarket.permitBuy(0, 0, sig);

        assertEq(token.balanceOf(alice), 0);
        assertEq(nft.ownerOf(0), address(alice));
    }
}
