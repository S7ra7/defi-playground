// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AMM.sol";
import "../src/MockERC20.sol";

contract AMMTest is Test {
    AMM amm;
    MockERC20 tokenX;
    MockERC20 tokenY;

    address user = address(0xBEEF);

    function setUp() public {
        // 3 argüman: name, symbol, decimals
        tokenX = new MockERC20("Token X", "TX", 18);
        tokenY = new MockERC20("Token Y", "TY", 18);

        // AMM kurucusu IERC20 bekliyor -> cast et
        amm = new AMM(IERC20(address(tokenX)), IERC20(address(tokenY)));

        // Kullanıcıya token bas
        tokenX.mint(user, 1_000 ether);
        tokenY.mint(user, 1_000 ether);

        // Onaylar ve likidite
        vm.startPrank(user);
        tokenX.approve(address(amm), type(uint256).max);
        tokenY.approve(address(amm), type(uint256).max);
        amm.addLiquidity(1_000 ether, 1_000 ether);
        vm.stopPrank();
    }

    function testSwapXforY() public {
        vm.startPrank(user);

        // minDy toleransı ile 2 parametre ver
        uint256 dx = 100 ether;
        uint256 quoted = amm.getAmountOut(dx);
        amm.swapXforY(dx, (quoted * 99) / 100); // %1 slippage

        // Kullanıcının Y bakiyesi artmış olmalı
        assertGt(tokenY.balanceOf(user), 900 ether);
        vm.stopPrank();
    }
}
