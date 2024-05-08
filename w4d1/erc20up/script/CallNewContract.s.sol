// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../src/MyTokenV2.sol";

contract CallContract is Script {
    function run() public {
        vm.startBroadcast();

        MyTokenV2 token = MyTokenV2(0x61FaBB15EaBdA12Beaccb4f3957E6f85f2e21284);
        string memory res = token.newFunc();
        console.log("new is ", res);

        vm.stopBroadcast();
    }
}
