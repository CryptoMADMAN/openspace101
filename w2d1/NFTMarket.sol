// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTMarket is IERC721Receiver {
    mapping(uint => uint) public tokenIdPrice;
    mapping(uint => address) public tokenSeller;
    IERC20 public immutable token;
    IERC721 public immutable nftToken;

    event OnERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes data
    );

    constructor(address _token, address _nftToken) {
        token = IERC20(_token);
        nftToken = IERC721(_nftToken);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    // approve(address to, uint256 tokenId) first
    function list(uint _tokenId, uint amount) public {
        nftToken.safeTransferFrom(msg.sender, address(this), _tokenId, "");
        tokenIdPrice[_tokenId] = amount;
        tokenSeller[_tokenId] = msg.sender;
    }

    function buy(uint _tokenId) external {
        require((nftToken).ownerOf(_tokenId) == address(this), "aleady selled");

        token.transferFrom(
            msg.sender,
            tokenSeller[_tokenId],
            tokenIdPrice[_tokenId]
        );
        nftToken.transferFrom(address(this), msg.sender, _tokenId);
    }
}
