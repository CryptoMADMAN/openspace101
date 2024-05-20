// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {MyERC20Permit} from '../src/copy/MyERC20Permit.sol';
import {NFTMarketPermit} from "../src/copy/NFTMarketPermit.sol";
import {MyERC721} from "../src/copy/MyERC721.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

contract AirdopMerkleNFTMarket is NFTMarketPermit{

    MyERC20Permit erc20;
    bytes32 immutable merkleRoot;
    
    constructor(address token_,address nft_,bytes32 merkleRoot_)NFTMarketPermit(token_,nft_){
        erc20=MyERC20Permit(token_);
        erc20.mint(msg.sender ,1e18);
        merkleRoot=merkleRoot_;

    }

    //使用token的permit进行授权
    function permitPreBuy(uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s)public {
        erc20.permit(msg.sender, address(this), amount, deadline, v, r, s);
    }

    // //通过默克尔树验证白名单，半价购买，并利用 permitPrePay 的授权，转入 token 转出 NFT
    function claimNFT(uint256 amount, uint256 tokenId, bytes32[] calldata merkleProof) public {
        require(_isWhite(merkleProof, msg.sender),'merkleVerify fails');
        require(nftToken.ownerOf(tokenId)==address(this),"not owner");
        
        require(tokenSeller[tokenId]!=address(0),"not list");
        require(amount>=tokenIdPrice[tokenId]/2,"amount is not enough,should be more than tokenIdPrice/2" );
        erc20.transferFrom(msg.sender, tokenSeller[tokenId], tokenIdPrice[tokenId]/2);
        nftToken.safeTransferFrom(address(this), msg.sender, tokenId);

        delete tokenIdPrice[tokenId];
        delete tokenSeller[tokenId];

    }
    function _isWhite(bytes32[] calldata merkleProof_,address leaf_) private view returns(bool){
        bytes32 node=keccak256(abi.encodePacked(leaf_));
        return MerkleProof.verify(merkleProof_, merkleRoot, node);
    }
    //copy from template
    function multicall(bytes[] calldata datas) public returns (bytes[] memory results) {
        results = new bytes[](datas.length);
        for (uint256 i = 0; i < datas.length; i++) {
            results[i] = Address.functionDelegateCall(address(this), datas[i]);
        }
        return results;
    }



}