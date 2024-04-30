// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyERC721 is ERC721URIStorage {
    uint256 public tid;

    constructor() ERC721("manson", "MSN") {}

    //  QmZNFPwox146ohY93ViFD8omSThRAVYF1A96MNHbWoa2Nr

    // ipfs://QmT4YDZ2dgTSpfHwPndnSuvHrAXNvtDBKNDUwN8nuZiVHT
    function mint(address _student, string memory _tokenURI) public returns (uint256) {
        _mint(_student, ++tid);
        _setTokenURI(tid, _tokenURI);

        return tid;
    }
}
