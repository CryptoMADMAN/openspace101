// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {NFTMarketWithCallBack} from "../src/NFTMarketWithCallBack.sol";
import {MyERC721} from "../src/NFT.sol";
import {BaseERC20WithCallBack} from "../src/BaseERC20WithCallBack.sol";
import {Transfer} from "../src/Events.sol";

contract NFTMarketWithCallBackTest is Test {
    NFTMarketWithCallBack mkt;
    MyERC721 nft;
    BaseERC20WithCallBack myToken;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    /// 运行测试前的执行代码，可用于准备测试的数据的执行
    function setUp() public {
        myToken = new BaseERC20WithCallBack("MM", "MM", 10000);
        myToken.transfer(alice, 10000);

        nft = new MyERC721();
        nft.mint(bob, "ipfs://QmcCVQfpeXPhAjwXQqaDpSezLy48ynLVuDXfUoct7figzr");

        mkt = new NFTMarketWithCallBack(address(myToken), address(nft));
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

    function test_TokensReceived() public {
        test_list();

        vm.startPrank(alice);
        require(myToken.balanceOf(alice) >= 1000, "eds balance");
        myToken.transferWithCallBack(address(mkt), 1000, abi.encode(1));
        assertEq(nft.ownerOf(1), alice);
    }


}
