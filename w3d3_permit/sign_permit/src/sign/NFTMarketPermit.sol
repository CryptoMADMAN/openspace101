// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {Nonces} from "@openzeppelin/contracts/utils/Nonces.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract NFTMarket is Nonces, IERC721Receiver {
    mapping(uint256 => uint256) public tokenIdPrice;
    mapping(uint256 => address) public tokenSeller;
    IERC20 public immutable token;
    IERC721 public immutable nftToken;
    address admin;

    event OnERC721Received(address operator, address from, uint256 tokenId, bytes data);

    constructor(address token_, address nftToken_) {
        token = IERC20(token_);
        nftToken = IERC721(nftToken_);
        admin = msg.sender;
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // approve(address to, uint256 tokenId) first
    function list(uint256 tokenId_, uint256 amount_) public {
        nftToken.safeTransferFrom(msg.sender, address(this), tokenId_, "");
        tokenIdPrice[tokenId_] = amount_;
        tokenSeller[tokenId_] = msg.sender;
    }

    function buy(uint256 tokenId_) public {
        require((nftToken).ownerOf(tokenId_) == address(this), "aleady selled");

        token.transferFrom(msg.sender, tokenSeller[tokenId_], tokenIdPrice[tokenId_]);
        nftToken.transferFrom(address(this), msg.sender, tokenId_);
    }

    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    function permitBuy(uint256 tokenId_, uint256 nonce, bytes calldata signature) public {
        _useCheckedNonce(msg.sender, nonce);

        bytes32 hash = keccak256(abi.encodePacked(msg.sender, nonce));
        hash = hash.toEthSignedMessageHash();
        address signAddr = hash.recover(signature);
        require(signAddr == admin, "error signiture");

        _useNonce(msg.sender);
        buy(tokenId_);
    }
}
