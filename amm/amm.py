from __future__ import annotations
from dataclasses import dataclass

@dataclass
class SwapResult:
    dx: float
    dy: float
    price_after: float

class ConstantProductAMM:
    """
    Basit x*y=k AMM simülatörü.
    fee: 0.003 => %0.3 işlem ücreti.
    """
    def __init__(self, x: float, y: float, fee: float = 0.003):
        assert x > 0 and y > 0, "pozitif rezerv olmalı"
        assert 0 <= fee < 0.1, "makul bir fee ver"
        self.x = float(x)
        self.y = float(y)
        self.k = self.x * self.y
        self.fee = float(fee)
        self.total_liquidity = (self.x * self.y) ** 0.5

    @property
    def price_xy(self) -> float:
        # 1 Y'nin X cinsinden fiyatı ~ x / y
        return self.x / self.y

    def _apply_fee(self, amount: float) -> float:
        return amount * (1 - self.fee)

    def swap_x_for_y(self, dx: float) -> SwapResult:
        assert dx > 0, "dx > 0 olmalı"
        dx_eff = self._apply_fee(dx)
        x_new = self.x + dx_eff
        y_new = self.k / x_new
        dy_out = self.y - y_new
        # state update
        self.x = x_new
        self.y = y_new
        return SwapResult(dx=dx, dy=dy_out, price_after=self.price_xy)

    def swap_y_for_x(self, dy: float) -> SwapResult:
        assert dy > 0, "dy > 0 olmalı"
        dy_eff = self._apply_fee(dy)
        y_new = self.y + dy_eff
        x_new = self.k / y_new
        dx_out = self.x - x_new
        # state update
        self.x = x_new
        self.y = y_new
        return SwapResult(dx=dx_out, dy=dy, price_after=self.price_xy)

    def add_liquidity(self, dx: float, dy: float) -> float:
        """Orantılı ekleme; dönen: basit LP payı."""
        assert dx > 0 and dy > 0
        share_x = dx / self.x
        share_y = dy / self.y
        assert abs(share_x - share_y) < 1e-6, "bu basit model orantılı ekleme ister"
        self.x += dx
        self.y += dy
        self.k = self.x * self.y
        minted = self.total_liquidity * share_x
        self.total_liquidity += minted
        return minted

    def remove_liquidity(self, share: float) -> tuple[float, float]:
        assert 0 < share <= self.total_liquidity
        proportion = share / self.total_liquidity
        dx = self.x * proportion
        dy = self.y * proportion
        self.x -= dx
        self.y -= dy
        self.k = self.x * self.y
        self.total_liquidity -= share
        return dx, dy
    def get_price_impact(self, dx: float) -> float:
        """
        Swap öncesi ve sonrası fiyat farkından 'price impact'i hesaplar (%).
        """
        p_before = self.price_xy
        res = self.swap_x_for_y(dx)
        p_after = res.price_after
        # işlemi geri al (state'i bozmamak için)
        self.x -= dx * (1 - self.fee)
        self.y = self.k / self.x
        impact = (p_after - p_before) / p_before * 100
        return impact

    def estimate_slippage(self, dx: float) -> float:
        """
        Slippage = (gerçek fiyat - beklenen fiyat) / beklenen fiyat (%)
        """
        p_expected = self.price_xy
        res = self.swap_x_for_y(dx)
        effective_price = dx / res.dy
        # state'i geri al
        self.x -= dx * (1 - self.fee)
        self.y = self.k / self.x
        slippage = (effective_price - p_expected) / p_expected * 100
        return slippage
