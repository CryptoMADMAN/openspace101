// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {IToken, IStaking} from "./IStoken.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

struct StakeInfo {
    uint128 userStake; //用户质押的ETH数量
    uint128 userCumulativeRewards; //记录用户 上次累计的回报数量
    uint256 userCumulativeRewardsPerToken; //记录用户 上次累计的单个ETH回报数量 扩大1e18
}

contract StakePool is IStaking {
    using SafeERC20 for IToken;
    using Address for address payable;

    mapping(address => StakeInfo) public stakes;
    uint256 _currCumulativeRewardsPerToken; //每个wei的ETH 积累了多少Token的奖励 1e18
    uint128 startNumber = uint128(block.number);

    uint128 _rate = 10 * 1e18; //每个区块的奖励代币数
    uint128 _totalStaked; //总质押的eth数，单位是wei

    IToken _reToken;

    uint128 _lastUpdateBlock = startNumber;

    constructor(address reToken_) {
        _reToken = IToken(reToken_);
    }

    function _updateReward() internal {
        if (_totalStaked == 0) {
            _lastUpdateBlock = uint128(block.number);
            return;
        }
        _currCumulativeRewardsPerToken += 1e18 * (block.number - _lastUpdateBlock) * _rate / _totalStaked;
        _lastUpdateBlock = uint128(block.number);
    }

    function _updateUserReward(StakeInfo storage stk) internal {
        stk.userCumulativeRewards += stk.userStake * uint128(_currCumulativeRewardsPerToken - stk.userCumulativeRewardsPerToken) / 1e18;
        stk.userCumulativeRewardsPerToken = _currCumulativeRewardsPerToken;
    }

    //  质押eth合约
    function stake() external payable {
        _updateReward();
        StakeInfo storage stk = stakes[msg.sender];
        _updateUserReward(stk);
        stk.userStake += uint128(msg.value);
        _totalStaked += uint128(msg.value);
    }

    function unstake(uint128 amt_) external payable {
        _updateReward();
        StakeInfo storage stk = stakes[msg.sender];
        require(stk.userStake >= amt_, "not enough balance");
        _updateUserReward(stk);
        stk.userStake -= amt_;
        _totalStaked -= amt_;
        Address.sendValue(payable(msg.sender), amt_);
    }

    //领取 代币收益
    function claim() external {
        _updateReward();
        StakeInfo storage stk = stakes[msg.sender];
        _updateUserReward(stk);
        if (stk.userCumulativeRewards == 0) {
            return;
        }
        _reToken.mint(msg.sender, stk.userCumulativeRewards);
        stk.userCumulativeRewards = 0;
    }

    function balanceOf(address addr) external view returns (uint256) {
        return stakes[address(addr)].userStake;
    }

    function viewRewards(address addr) external view returns (uint256) {
        if (_totalStaked == 0) return 0;
        uint256 currCumulativeRewardsPerToken =
            _currCumulativeRewardsPerToken + 1e18 * (block.number - _lastUpdateBlock) * _rate / _totalStaked;
        StakeInfo storage stk = stakes[addr];
        return stk.userCumulativeRewards
            + stk.userStake * (currCumulativeRewardsPerToken - stk.userCumulativeRewardsPerToken) / 1e18;
    }
}
