// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ProxyContract {
    address public currentLogic;
    address public admin;

    constructor(address _logic) {
        currentLogic = _logic;
        admin = msg.sender;
    }

    fallback() external payable {
        address _impl = currentLogic;
        require(_impl != address(0), "Logic contract address is zero");

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }

    function upgradeLogic(address _newLogic) external {
        require(msg.sender == admin, "Only admin can upgrade logic");
        currentLogic = _newLogic;
    }
}
