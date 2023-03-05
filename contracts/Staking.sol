// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@thirdweb-dev/contracts/extension/Staking20.sol";
import "@thirdweb-dev/contracts/eip/interface/IERC20.sol";
import "@thirdweb-dev/contracts/eip/interface/IERC20Metadata.sol";

contract Staking is Staking20 {
    // ERC20 Reward Token address. See {_mintRewards}.
    address public rewardToken;

    /**
     *  We store the contract deployer's address only for the purposes of the example
     *  in the code comment below.
     *
     *  Doing this is not necessary to use the `Staking20` extension.
     */
    address public deployer;

    constructor(
        uint256 _timeUnit,
        uint256 _rewardRatioNumerator,
        uint256 _rewardRatioDenominator,
        address _stakingToken,
        address _rewardToken,
        address _nativeTokenWrapper
    )
        Staking20(
            _nativeTokenWrapper,
            _stakingToken,
            IERC20Metadata(_stakingToken).decimals(),
            IERC20Metadata(_rewardToken).decimals()
        )
    {
        _setStakingCondition(
            _timeUnit,
            _rewardRatioNumerator,
            _rewardRatioDenominator
        );

        rewardToken = _rewardToken;
        deployer = msg.sender;
    }

    /**
     *  @dev    Mint/Transfer ERC20 rewards to the staker. Must override.
     *
     *  @param _staker    Address for sending rewards to.
     *  @param _rewards   Amount of tokens to be given out as reward.
     *
     */
    function _mintRewards(address _staker, uint256 _rewards) internal override {
        IERC20(rewardToken).transfer(_staker, _rewards);
    }

    // Returns whether staking restrictions can be set in given execution context.
    function _canSetStakeConditions() internal view override returns (bool) {
        return msg.sender == deployer;
    }

    function getRewardTokenBalance()
        external
        view
        virtual
        override
        returns (uint256 _rewardsAvailableInContract)
    {
        _rewardsAvailableInContract = IERC20(rewardToken).balanceOf(
            address(this)
        );

        if (stakingToken == rewardToken) {
            _rewardsAvailableInContract =
                _rewardsAvailableInContract -
                stakingTokenBalance;
        }
    }
}
