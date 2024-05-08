// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Options} from "openzeppelin-foundry-upgrades/Options.sol";
import "../src/MyToken.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import "forge-std/Script.sol";

contract DeployUUPSNEWProxy is Script {
    function run() public {
        vm.startBroadcast();
        Options memory ops;
        ops.unsafeSkipAllChecks = true;
        // Deploy the proxy contract with the implementation address and initializer
        address proxy = Upgrades.deployUUPSProxy("MyToken.sol", abi.encodeCall(MyToken.initialize, (msg.sender)), ops);

        vm.stopBroadcast();
        // Log the proxy address
        console.log("UUPS Proxy Address:", address(proxy));
    }
}
