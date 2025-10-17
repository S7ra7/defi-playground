// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address, address, uint256) external returns (bool);
    function transfer(address, uint256) external returns (bool);
    function balanceOf(address) external view returns (uint256);
    function approve(address, uint256) external returns (bool);
}

contract AMM {
    IERC20 public immutable tokenX;
    IERC20 public immutable tokenY;
    uint24 public constant FEE = 3000; // 0.30% = 3000 / 1e6
    uint256 private constant ONE = 1_000_000;

    constructor(IERC20 _x, IERC20 _y) {
        tokenX = _x; tokenY = _y;
    }

    function reserves() public view returns (uint256 rx, uint256 ry) {
        rx = tokenX.balanceOf(address(this));
        ry = tokenY.balanceOf(address(this));
    }

    function addLiquidity(uint256 dx, uint256 dy) external {
        require(dx > 0 && dy > 0, "zero");
        require(tokenX.transferFrom(msg.sender, address(this), dx));
        require(tokenY.transferFrom(msg.sender, address(this), dy));
    }

    function getAmountOut(uint256 dx) public view returns (uint256 dy) {
        (uint256 x, uint256 y) = reserves();
        require(dx > 0 && x > 0 && y > 0, "reserves");
        uint256 dxEff = dx * (ONE - FEE) / ONE;
        uint256 xNew = x + dxEff;
        uint256 yNew = (x * y) / xNew;
        dy = y - yNew;
    }

    function swapXforY(uint256 dx, uint256 minDy) external returns (uint256 dy) {
        require(tokenX.transferFrom(msg.sender, address(this), dx));
        dy = getAmountOut(dx);
        require(dy >= minDy, "slippage");
        require(tokenY.transfer(msg.sender, dy));
    }
}
