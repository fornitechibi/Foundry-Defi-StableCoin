// SPDX-License-Identifier: MIT

// 1.The total supply of dsc should always be less than the total value of collateral
// 2.Getter functions should never revert

pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {DeployDSC} from "../../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../../src/DecentralizedStableCoin.sol";
import {HelperConfig} from "../../../script/HelperConfig.s.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {Handler} from "./Handler.t.sol";

contract InvariantsTests is StdInvariant, Test {
    DeployDSC deployer;
    DSCEngine dsce;
    DecentralizedStableCoin dsc;
    HelperConfig config;
    address weth;
    address wbtc;
    Handler handler;

    function setUp() external {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (,, weth, wbtc,) = config.activeNetworkConfig();
        //targetContract(address(dsce));
        handler = new Handler(dsce, dsc);
        targetContract(address(handler));
    }

    function invariant_protocolMustHaveMoreThanTotalSupply() public view {
        // get the value of all collateral in the protocol
        // compare with the value of debt(dsc)
        uint256 totalSupply = dsc.totalSupply();
        uint256 totalWethDeposisted = IERC20(weth).balanceOf(address(dsce));
        uint256 totalBtcDeposisted = IERC20(wbtc).balanceOf(address(dsce));

        uint256 wethValue = dsce.getUsdValue(weth, totalWethDeposisted);
        uint256 wbtcValue = dsce.getUsdValue(wbtc, totalBtcDeposisted);

        // console.log("weth value: ", wethValue);
        // console.log("wbtc value: ", wbtcValue);
        // console.log("total supply: ", totalSupply);
        // console.log("time mint called: ", handler.timesMintdscCalled());

        assert(wethValue + wbtcValue >= totalSupply);
    }

    function invariant_gettersShouldNotRevert() public view {
        dsce.getHealthFactor();
        dsce.getPrecision();
        dsce.getAdditionalFeedPrecision();
    }
}
