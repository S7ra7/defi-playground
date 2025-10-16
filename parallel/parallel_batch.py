# Basit paralel hesap: farklı dx değerleri için AMM price impact (%)
# Not: AMM state'ini bozmamak için kapalı formül kullanıyoruz.

from concurrent.futures import ThreadPoolExecutor, as_completed

def _preview_swap_x_for_y(x: float, y: float, fee: float, dx: float):
    k = x * y
    dx_eff = dx * (1 - fee)
    x_new = x + dx_eff
    y_new = k / x_new
    dy_out = y - y_new
    price_before = x / y
    price_after = x_new / y_new
    effective_price = dx / dy_out
    impact_pct = (price_after - price_before) / price_before * 100
    slippage_pct = (effective_price - price_before) / price_before * 100
    return impact_pct, slippage_pct

def price_impact_for_dx(dx: float, x0: float = 1000.0, y0: float = 1000.0, fee: float = 0.003) -> float:
    impact, _ = _preview_swap_x_for_y(x0, y0, fee, dx)
    return impact

def run_batch(dxs, max_workers: int = 4):
    """
    dxs: [10, 50, 100, ...]
    Dönen: dx sırasına göre impact listesi.
    """
    # Sonuçları sıralı döndürmek için index ile map'liyoruz
    results = [None] * len(dxs)
    with ThreadPoolExecutor(max_workers=max_workers) as ex:
        futures = {ex.submit(price_impact_for_dx, dx): i for i, dx in enumerate(dxs)}
        for fut in as_completed(futures):
            i = futures[fut]
            results[i] = fut.result()
    return results
