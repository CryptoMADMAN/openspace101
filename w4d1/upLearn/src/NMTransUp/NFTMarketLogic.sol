// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
contract NFTMarketLogic is IERC721Receiver, Initializable {
    mapping(uint256 => uint256) public tokenIdPrice;
    mapping(uint256 => address) public tokenSeller;
    IERC20 public token;
    IERC721 public nftToken;

    event OnERC721Received(address operator, address from, uint256 tokenId, bytes data);

    function initialize(address _token, address _nftToken) public initializer {
        token = IERC20(_token);
        nftToken = IERC721(_nftToken);
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function list(uint256 _tokenId, uint256 amount) public {
        nftToken.safeTransferFrom(msg.sender, address(this), _tokenId, "");
        tokenIdPrice[_tokenId] = amount;
        tokenSeller[_tokenId] = msg.sender;
    }

    function buy(uint256 _tokenId) external {
        require(nftToken.ownerOf(_tokenId) == address(this), "Not available for sale");

        token.transferFrom(msg.sender, tokenSeller[_tokenId], tokenIdPrice[_tokenId]);
        nftToken.transferFrom(address(this), msg.sender, _tokenId);
    }
}
