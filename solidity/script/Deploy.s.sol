// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AMM.sol";
import "../src/MockERC20.sol";
import "../src/Lending.sol";

contract Deploy is Script {
    function run() external {
        // Simülasyon modunda PRIVATE_KEY gerekmiyor; Foundry local VM'inde çalışır.
        // Eğer bir gün anvil'e yayınlamak istersen, CI'de PRIVATE_KEY tanımlarsın:
        // uint256 pk = vm.envOr("PRIVATE_KEY", uint256(0));
        // pk != 0 ? vm.startBroadcast(pk) : vm.startBroadcast();

        vm.startBroadcast();

        // Tokenlar ve AMM
        MockERC20 tokenX = new MockERC20("Token X", "TX", 18);
        MockERC20 tokenY = new MockERC20("Token Y", "TY", 18);
        AMM amm = new AMM(IERC20(address(tokenX)), IERC20(address(tokenY)));

        // Likidite ekle (simülasyonda msg.sender = yayıncı anahtar)
        tokenX.mint(msg.sender, 1_000e18);
        tokenY.mint(msg.sender, 1_000e18);
        tokenX.approve(address(amm), type(uint256).max);
        tokenY.approve(address(amm), type(uint256).max);
        amm.addLiquidity(1_000e18, 1_000e18);

        // Basit bir swap
        uint256 quoted = amm.getAmountOut(100e18);
        uint256 dy = amm.swapXforY(100e18, (quoted * 90) / 100);

        // Lending kontratı
        Lending lend = new Lending(
            IERC20Like(address(tokenX)),
            IERC20Like(address(tokenY)),
            7000,  // LTV %70
            8000,  // Liquidation threshold %80
            1000e18
        );

        vm.stopBroadcast();

        // Loglar CI konsolunda görünsün
        console2.log("Deployer:", msg.sender);
        console2.log("TokenX :", address(tokenX));
        console2.log("TokenY :", address(tokenY));
        console2.log("AMM    :", address(amm));
        console2.log("Lending:", address(lend));
        console2.log("Swap dy:", dy);
    }
}
