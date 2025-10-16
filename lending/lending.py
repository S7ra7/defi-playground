from dataclasses import dataclass

@dataclass
class Position:
    collateral: float  # teminat miktarı (ör. ETH)
    debt: float        # borç (ör. USDC)
    price: float       # teminatın fiyatı (USDC cinsinden 1 birim başına)
    ltv: float         # max borç/teminat_değeri (örn: 0.7)
    liq_threshold: float  # likidasyon eşiği (örn: 0.8)
    rate_apy: float = 0.0  # basit APY (örn: 0.05 => %5)

    @property
    def collateral_value(self) -> float:
        return self.collateral * self.price

    @property
    def cr(self) -> float:
        """Collateral Ratio ~ borcu teminat değerine oran; burada debt/collateral_value."""
        if self.collateral_value == 0:
            return float("inf")
        return self.debt / self.collateral_value

    def can_borrow_more(self, amount: float) -> bool:
        return (self.debt + amount) <= self.collateral_value * self.ltv

    def borrow(self, amount: float):
        assert amount >= 0
        assert self.can_borrow_more(amount), "LTV sınırı aşılıyor"
        self.debt += amount

    def repay(self, amount: float):
        assert amount >= 0
        self.debt = max(0.0, self.debt - amount)

    def accrue_interest(self, years: float):
        """Basit faiz: debt = debt * (1 + rate_apy * t)"""
        assert years >= 0
        self.debt *= (1 + self.rate_apy * years)

    def is_liquidatable(self) -> bool:
        # debt > collateral_value * liq_threshold
        return self.debt > self.collateral_value * self.liq_threshold

    def update_price(self, new_price: float):
        assert new_price > 0
        self.price = new_price
