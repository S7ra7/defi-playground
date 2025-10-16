from lending.lending import Position

def test_borrow_and_limits():
    p = Position(collateral=10, debt=0, price=2000, ltv=0.7, liq_threshold=0.8, rate_apy=0.05)
    # Teminat değeri = 10 * 2000 = 20000; max borç = 20000 * 0.7 = 14000
    assert p.can_borrow_more(1000)
    p.borrow(1000)
    assert p.debt == 1000
    # sınırı zorla
    assert not p.can_borrow_more(20000)

def test_interest_and_liquidation():
    p = Position(collateral=5, debt=3000, price=1000, ltv=0.7, liq_threshold=0.8, rate_apy=0.10)
    assert not p.is_liquidatable()  # 3000 < 4000

    # Fiyat yeterince düşerse likidasyon başlar
    p.update_price(700)             # teminat değeri = 3500, eşik = 2800, 3000 > 2800 -> likidasyon
    assert p.is_liquidatable()

    # Borcu azaltınca kurtarabilir
    p.repay(500)                    # debt: 2500
    assert p.debt == 2500
    assert not p.is_liquidatable()  # artık güvenli

    # Faiz eklendiğinde yeniden riskli hale gelebilir
    p.accrue_interest(1.0)
    assert p.debt > 2500
