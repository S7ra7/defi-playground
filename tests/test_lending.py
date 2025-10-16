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
    p = Position(collateral=5, debt=5000, price=1000, ltv=0.7, liq_threshold=0.8, rate_apy=0.10)
    # Başlangıçta borç eşikten büyük: likidasyona açık olmalı
    assert p.is_liquidatable()

    # Fiyat düşerse zaten likide kalır veya daha da kötüleşir
    p.update_price(800)  # teminat değeri 4000 -> hala likidite riski yüksek
    assert p.is_liquidatable()

    # Borcu azaltınca kurtarabilir
    p.repay(1500)        # debt: 3500
    assert p.debt == 3500
    assert not p.is_liquidatable()

    # Faiz ekleyelim (1 yıl %10) -> borç artar
    p.accrue_interest(1.0)
    assert p.debt > 3500
