// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AMM.sol";
import "../src/MockERC20.sol";

contract AMMTest is Test {
    AMM amm;
    MockERC20 tokenX;
    MockERC20 tokenY;

    function setUp() public {
        tokenX = new MockERC20("Token X", "TX", 18);
        tokenY = new MockERC20("Token Y", "TY", 18);
        amm = new AMM(address(tokenX), address(tokenY));

        tokenX.mint(address(this), 1e24);
        tokenY.mint(address(this), 1e24);

        tokenX.approve(address(amm), type(uint256).max);
        tokenY.approve(address(amm), type(uint256).max);
    }

    function testSwapForY() public {
        amm.addLiquidity(1e21, 1e21);

        uint256 beforeY = tokenY.balanceOf(address(this));
        amm.swapXforY(1e20);
        uint256 afterY = tokenY.balanceOf(address(this));

        assertGt(afterY, beforeY, "Y token balance did not increase");
    }
}
