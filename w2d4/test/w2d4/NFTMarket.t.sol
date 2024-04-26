// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NFTMarket} from "../../src/w2d4/NFTMarket.sol";
import {MyERC721} from "../../src/w2d4/NFT.sol";
import {BaseERC20} from "../../src/w2d4/BaseERC20.sol";

contract NFTMarketTest is Test {
    NFTMarket mkt;
    MyERC721 nft;
    BaseERC20 myToken;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    /// 运行测试前的执行代码，可用于准备测试的数据的执行
    function setUp() public {
        myToken = new BaseERC20("MM", "MM", 10000);
        myToken.transfer(alice, 10000);

        nft = new MyERC721();
        nft.mint(bob, "ipfs://QmcCVQfpeXPhAjwXQqaDpSezLy48ynLVuDXfUoct7figzr");

        mkt = new NFTMarket(address(myToken), address(nft));
    }

    /// 测试如果没有授权NFT,则无法list的成功
    function test_list() public {
        uint256 tokenId = 1;
        vm.startPrank(bob);
        nft.setApprovalForAll(address(mkt), true);
        mkt.list(tokenId, 1000);
        vm.stopPrank();
        assertEq(mkt.tokenSeller(tokenId), bob);
    }

    function test_listANDsell() public {
        uint256 tokenId = 1;
        test_list();
        vm.startPrank(alice);
        myToken.approve(address(mkt), 1000);
        mkt.buy(tokenId);
        vm.stopPrank();
        assertEq(nft.ownerOf(tokenId), alice);
    }
}
