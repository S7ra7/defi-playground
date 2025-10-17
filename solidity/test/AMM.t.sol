// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AMM.sol";
import "../src/MockERC20.sol";

contract AMMTest is Test {
    AMM amm;
    MockERC20 tokenX;
    MockERC20 tokenY;

    address lp     = address(0xA11CE); // likidite sağlayıcı
    address trader = address(0xBEEF);  // takas yapan

    function setUp() public {
        tokenX = new MockERC20("Token X", "TX", 18);
        tokenY = new MockERC20("Token Y", "TY", 18);

        // AMM kurucusu IERC20 bekliyor
        amm = new AMM(IERC20(address(tokenX)), IERC20(address(tokenY)));

        // LP'ye havuz için token bas
        tokenX.mint(lp,     1_000 ether);
        tokenY.mint(lp,     1_000 ether);

        // Trader'a swap için X bas
        tokenX.mint(trader,   500 ether);

        // LP havuza likidite ekler
        vm.startPrank(lp);
        tokenX.approve(address(amm), type(uint256).max);
        tokenY.approve(address(amm), type(uint256).max);
        amm.addLiquidity(1_000 ether, 1_000 ether);
        vm.stopPrank();

        // Trader AMM'ye onay verir
        vm.startPrank(trader);
        tokenX.approve(address(amm), type(uint256).max);
        vm.stopPrank();
    }

    function testSwapXforY() public {
        vm.startPrank(trader);
        uint256 dx = 100 ether;
        uint256 quoted = amm.getAmountOut(dx);
        amm.swapXforY(dx, (quoted * 99) / 100); // %1 slippage toleransı
        vm.stopPrank();

        // Trader'ın Y bakiyesi artmış olmalı
        assertGt(tokenY.balanceOf(trader), 0, "trader did not receive Y");
    }
}
