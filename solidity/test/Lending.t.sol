// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Lending.sol";
import "../src/MockERC20.sol";

contract LendingTest is Test {
    MockERC20 WETH;
    MockERC20 USDC; // mock 18 decimals
    Lending lend;
    address user = address(0xCAFE);

    function setUp() public {
        // 3 argüman: name, symbol, decimals
        WETH = new MockERC20("WETH", "WETH", 18);
        USDC = new MockERC20("USDC", "USDC", 18);

        // 1 WETH = 1000 USDC (1e18 ölçekle)
        lend = new Lending(
            IERC20Like(address(WETH)),
            IERC20Like(address(USDC)),
            7000,  // LTV %70
            8000,  // Liq %80
            1000 ether
        );

        // Kullanıcı ve havuz bakiyeleri
        WETH.mint(user, 10 ether);
        USDC.mint(address(lend), 100_000 ether);
    }

    function testBorrowAndLiquidation() public {
        vm.startPrank(user);
        WETH.approve(address(lend), type(uint256).max);
        USDC.approve(address(lend), type(uint256).max);

        // 5 WETH teminat (değer: 5000 USDC)
        lend.depositCollateral(5 ether);

        // 3000 USDC borç (LTV içinde)
        lend.borrow(3000 ether);
        vm.stopPrank();

        // Fiyat düşünce likide edilebilir hale gelsin
        lend.setPrice(700 ether); // 1 WETH = 700 USDC -> değer 3500
        assertTrue(lend.isLiquidatable(user));

        // Bir miktar geri ödeyince eşik altına düşsün
        vm.startPrank(user);
        lend.repay(700 ether); // borç 2300 olur
        vm.stopPrank();

        assertFalse(lend.isLiquidatable(user));
    }
}
