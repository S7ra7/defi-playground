import math
from amm.amm import ConstantProductAMM

def test_price_and_swap():
    amm = ConstantProductAMM(1000, 1000, fee=0.003)
    p0 = amm.price_xy
    res = amm.swap_x_for_y(100)
    assert res.dy > 0
    assert amm.price_xy > p0  # x arttı, fiyat yükseldi

def test_liquidity_flow():
    amm = ConstantProductAMM(1000, 1000)
    liq0 = amm.total_liquidity
    minted = amm.add_liquidity(100, 100)
    assert minted > 0
    assert math.isclose(amm.total_liquidity, liq0 + minted, rel_tol=1e-6)
    dx, dy = amm.remove_liquidity(minted)
    assert dx > 0 and dy > 0

