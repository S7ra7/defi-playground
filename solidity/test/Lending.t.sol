// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Lending.sol";
import "../src/MockERC20.sol";

contract LendingTest is Test {
    MockERC20 WETH;
    MockERC20 USDC; // 18 decimals mock
    Lending lend;
    address user = address(0xCAFE);

    function setUp() public {
        WETH = new MockERC20("WETH", "WETH");
        USDC = new MockERC20("USDC", "USDC");
        // 1 WETH = 1000 USDC (1e18 ölçeğiyle)
        lend = new Lending(IERC20Like(address(WETH)), IERC20Like(address(USDC)), 7000, 8000, 1000 ether);
        WETH.mint(user, 10 ether);
        USDC.mint(address(lend), 100_000 ether); // havuza borç parası
    }

    function testBorrowAndLiquidation() public {
        vm.startPrank(user);
        WETH.approve(address(lend), type(uint256).max);
        USDC.approve(address(lend), type(uint256).max);

        lend.depositCollateral(5 ether); // değer: 5000
        lend.borrow(3000 ether);         // LTV %70 sınırı içinde

        // Fiyat düşerse likidasyon eşiğini aşabilir
        vm.stopPrank();
        lend.setPrice(700 ether);        // değer: 3500
        assertTrue(lend.isLiquidatable(user));

        vm.startPrank(user);
        lend.repay(600 ether);           // 2400 borç
        assertFalse(lend.isLiquidatable(user));
        vm.stopPrank();
    }
}
