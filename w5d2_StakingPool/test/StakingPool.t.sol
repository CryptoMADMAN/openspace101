// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {StakePool} from "../src/StakingPool.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IToken} from "../src/ISToken.sol";

contract StakingPoolTest is Test {
    StakePool pool;
    ReToken reToken;

    address alice;
    address bob;

    function setUp() public {
        reToken = new ReToken("RE", "RE");
        pool = new StakePool(address(reToken));

        alice = makeAddr("adlice");
        bob = makeAddr("bob");
        vm.deal(alice, 1000);
        vm.deal(bob, 1000);
    }

    function test_stake() public {
        //初始区块为1
        vm.startPrank(alice);
        pool.stake{value: 1000}();
        assertEq(pool.balanceOf(address(alice)), 1000);
        console.log("blocknum", block.number);
        vm.roll(2);
        console.log("blocknum", block.number);

        assertEq(pool.viewRewards(address(alice)), 10 * 1e18);

        vm.stopPrank();
        vm.startPrank(bob);
        pool.stake{value: 1000}();

        vm.roll(5);
        assertEq(pool.viewRewards(address(alice)), 25 * 1e18); // 10 + (5-2)*10/2
        assertEq(pool.viewRewards(address(bob)), 15 * 1e18);
        vm.stopPrank();
    }

    function test_unstake() public {
        test_stake();
        vm.startPrank(alice);
        pool.unstake(1000);
        assertEq(pool.balanceOf(address(alice)), 0);
        assertEq(alice.balance, 1000);
    }

    function test_claim() public {
        test_stake();

        vm.roll(10);
        vm.startPrank(alice);
        pool.claim();
        assertEq(reToken.balanceOf(alice), (10 + 8 * 10 / 2) * 1e18);
        vm.stopPrank();
    }
}

contract ReToken is ERC20, IToken {
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        _mint(msg.sender, 1000000 * 1e18);
    }

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
