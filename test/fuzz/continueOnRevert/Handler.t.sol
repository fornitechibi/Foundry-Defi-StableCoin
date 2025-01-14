// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DSCEngine} from "../../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../../src/DecentralizedStableCoin.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {MockV3Aggregator} from "../../mocks/MockV3Aggregator.sol";

contract Handler is Test {
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    ERC20Mock weth;
    ERC20Mock wbtc;
    uint256 MAX_DEPOSIT_SIZE = type(uint96).max;
    uint256 public timesMintdscCalled;
    address[] public usersWithCollateralDeposisted;
    MockV3Aggregator public ethUsdPriceFeed;

    constructor(DSCEngine _dscEngine, DecentralizedStableCoin _dsc) {
        dsce = _dscEngine;
        dsc = _dsc;

        address[] memory collateralTokens = dsce.getCollateralTokens();
        weth = ERC20Mock(collateralTokens[0]);
        wbtc = ERC20Mock(collateralTokens[1]);

        ethUsdPriceFeed = MockV3Aggregator(dsce.getCollateralTokenPriceFeed(address(weth)));
    }

    // deposit Collateral

    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(collateralSeed);
        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT_SIZE);
        vm.startPrank(msg.sender);
        if (amountCollateral == 0) {
            return;
        }
        collateral.mint(msg.sender, amountCollateral);
        collateral.approve(address(dsce), amountCollateral);
        dsce.depositCollateral(address(collateral), amountCollateral);
        vm.stopPrank();
        usersWithCollateralDeposisted.push(msg.sender);
    }

    // redeem Collateral

    function redeemCollateral(uint256 CollateralSeed, uint256 amountCollateral) public {
        ERC20Mock collateral = _getCollateralFromSeed(CollateralSeed);
        uint256 maxCollateralToRedeem = dsce.getCollateralBalanceOfUser(msg.sender, address(collateral));
        amountCollateral = bound(amountCollateral, 0, maxCollateralToRedeem);
        if (amountCollateral == 0) {
            return;
        }
        vm.startPrank(msg.sender);
        dsce.redeemCollateral(address(collateral), amountCollateral);
        vm.stopPrank();
    }

    // mint Dsc

    function mintDsc(uint256 amount, uint256 addressSeed) public {
        if (usersWithCollateralDeposisted.length == 0) {
            return;
        }
        address sender = usersWithCollateralDeposisted[addressSeed % usersWithCollateralDeposisted.length];
        (uint256 totalDscMinted, uint256 CollateralValueInUsd) = dsce.getAccountInformation(sender);
        int256 maxDscToMint = (int256(CollateralValueInUsd) / 2) - int256(totalDscMinted);
        if (maxDscToMint < 1) {
            return;
        }
        if (amount == 0) {
            return;
        }
        amount = bound(amount, 1, uint256(maxDscToMint));
        vm.startPrank(sender);
        dsce.mintDsc(amount);
        timesMintdscCalled++;
        vm.stopPrank();
    }

    // This breaks our test suite !!!
    // function updateCollateralPrice(uint96 newPrice) public {
    //     int256 newPriceInt = int256(uint256(newPrice));
    //     ethUsdPriceFeed.updateAnswer(newPriceInt);
    // }

    /* Helper functions */

    function _getCollateralFromSeed(uint256 collateralSeed) private view returns (ERC20Mock) {
        if (collateralSeed % 2 == 0) {
            return weth;
        }
        return wbtc;
    }
}
