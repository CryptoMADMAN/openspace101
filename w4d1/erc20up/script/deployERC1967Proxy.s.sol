// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../src/MyToken.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "forge-std/Script.sol";

contract DeployUUPSERC1967Proxy is Script {
    function run() public {
        // 0x766e8Ca3cF99EB1f476A1F5d85228e5fd69AeB35
        // address _implementation = YOUR_DEPLOYED_SMART_CONTRACT_ADDRESS; // Replace with your token address
        address _implementation = 0x43F2E059Df91777cfFE108bA5b8509Aae1407A36; // Replace with your token address
        vm.startBroadcast();

  

        // Encode the initializer function call
        bytes memory data = abi.encodeWithSelector(
            MyToken(_implementation).initialize.selector,
            msg.sender // Initial owner/admin of the contract
        );

        // Deploy the proxy contract with the implementation address and initializer
        ERC1967Proxy proxy = new ERC1967Proxy(_implementation, data);

        vm.stopBroadcast();
        // Log the proxy address
        console.log("UUPS Proxy Address:", address(proxy));
    }
}
