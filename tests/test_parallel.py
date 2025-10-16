from parallel.parallel_batch import run_batch, price_impact_for_dx

def test_parallel_batch_basic():
    dxs = [10, 50, 100]
    impacts = run_batch(dxs, max_workers=3)
    assert len(impacts) == len(dxs)
    # dx büyüdükçe impact artmalı
    assert impacts[0] < impacts[1] < impacts[2]

def test_single_price_impact():
    # örnek kontrol: pozitif olmalı ve makul aralıkta
    imp = price_impact_for_dx(80)
    assert imp > 0
    assert imp < 25
