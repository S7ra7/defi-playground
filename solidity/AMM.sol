function swapXforY(uint256 dx, uint256 minDy) external returns (uint256 dy) {
    // 1) Mevcut rezervlerden çıkış miktarını hesapla (pre-swap state)
    (uint256 x, uint256 y) = reserves();
    require(dx > 0 && x > 0 && y > 0, "reserves");

    uint256 dxEff = dx * (ONE - FEE) / ONE;  // 0.30% fee
    uint256 xNew  = x + dxEff;
    uint256 yNew  = (x * y) / xNew;
    dy = y - yNew;

    // 2) Slippage kontrolü (hesaplanan dy'ye göre)
    require(dy >= minDy, "slippage");

    // 3) Fonları hareket ettir
    require(tokenX.transferFrom(msg.sender, address(this), dx));
    require(tokenY.transfer(msg.sender, dy));
}

