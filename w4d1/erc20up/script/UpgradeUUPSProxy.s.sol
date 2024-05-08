pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {Options} from "openzeppelin-foundry-upgrades/Options.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import "../src/MyTokenV2.sol";

contract UpgradeUUPSProxy is Script {
    function run() public {
        vm.startBroadcast();
        Options memory ops;
        ops.unsafeSkipAllChecks = true;

        address proxy = 0x61FaBB15EaBdA12Beaccb4f3957E6f85f2e21284;

        // Deploy the proxy contract with the implementation address and initializer
        Upgrades.upgradeProxy(proxy, "MyTokenV2.sol", "", ops);

        vm.stopBroadcast();
        // Log the proxy address
        console.log("UUPS Proxy Address:", address(proxy));
    }
}
