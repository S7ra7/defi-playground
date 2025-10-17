// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AMM.sol";
import "../src/MockERC20.sol";
import "../src/Lending.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        // Tokens & AMM
        MockERC20 tokenX = new MockERC20("Token X", "TX", 18);
        MockERC20 tokenY = new MockERC20("Token Y", "TY", 18);
        AMM amm = new AMM(IERC20(address(tokenX)), IERC20(address(tokenY)));

        // Likidite + takas için yeterli bakiye
        tokenX.mint(msg.sender, 2_000e18);
        tokenY.mint(msg.sender, 2_000e18);

        tokenX.approve(address(amm), type(uint256).max);
        tokenY.approve(address(amm), type(uint256).max);

        // Likidite ekle
        amm.addLiquidity(1_000e18, 1_000e18);

        // Swap
        uint256 quoted = amm.getAmountOut(100e18);
        uint256 minOut = (quoted * 90) / 100;
        uint256 dy = amm.swapXforY(100e18, minOut);

        // Lending
        Lending lend = new Lending(
            IERC20Like(address(tokenX)),
            IERC20Like(address(tokenY)),
            7000,     // LTV %70
            8000,     // Likidasyon eşiği %80
            1_000e18  // Interest base
        );

        vm.stopBroadcast();

        // Loglar
        console2.log("Deployer:", msg.sender);
        console2.log("TokenX :", address(tokenX));
        console2.log("TokenY :", address(tokenY));
        console2.log("AMM    :", address(amm));
        console2.log("Lending:", address(lend));
        console2.log("Swap dy:", dy);
    }
}
