// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AMM.sol";
import "../src/MockERC20.sol";

contract AMMTest is Test {
    MockERC20 X;
    MockERC20 Y;
    AMM amm;
    address user = address(0xBEEF);

    function setUp() public {
        X = new MockERC20("X", "X");
        Y = new MockERC20("Y", "Y");
        amm = new AMM(IERC20(address(X)), IERC20(address(Y)));

        X.mint(user, 1_000 ether);
        Y.mint(user, 1_000 ether);

        vm.startPrank(user);
        X.approve(address(amm), type(uint256).max);
        Y.approve(address(amm), type(uint256).max);
        amm.addLiquidity(1_000 ether, 1_000 ether);
        vm.stopPrank();
    }

    function testSwapXforY() public {
        vm.startPrank(user);
        uint256 dy = amm.getAmountOut(100 ether);
        uint256 yBefore = Y.balanceOf(user);
        amm.swapXforY(100 ether, dy * 99 / 100); // %1 slippage toleransı
        uint256 yAfter = Y.balanceOf(user);
        assertGt(yAfter, yBefore);
        vm.stopPrank();
    }
}
