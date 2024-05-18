// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/Nonces.sol";

contract My721Contract is EIP712, Nonces {
    using ECDSA for bytes32;

    address owner;
    string private constant SIGNING_DOMAIN = "MyDomain";
    string private constant SIGNATURE_VERSION = "1";

    constructor() EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) {
        owner = msg.sender;
    }

    function getNonce(address user) public view returns (uint256) {
        return nonces(user);
    }

    function getDomainSeparator() public view returns (bytes32) {
        return _domainSeparatorV4();
    }

    function verifySignature(address user, uint256 amount, bytes memory signature) public view returns (bool) {
        uint256 nonce = getNonce(user);
        bytes32 structHash = keccak256(
            abi.encode(keccak256("MyMessage(address user,uint256 amount,uint256 nonce)"), user, amount, nonce)
        );
        bytes32 hash = _hashTypedDataV4(structHash);
        address signer = hash.recover(signature);
        return signer == user;
    }

    function executeTransaction(address user, uint256 amount, bytes memory signature) public {
        require(verifySignature(user, amount, signature), "Invalid signature");

        // 执行交易逻辑，比如转账
        // ...

        // 更新 nonce
        // _nonces[user]++;
        _useNonce(user);
    }
}
