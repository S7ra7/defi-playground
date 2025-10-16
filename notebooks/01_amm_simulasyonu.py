# AMM (x*y=k) mini simülasyon
# Bu dosya grafikleri kaydeder (docs/plots/ içinde). Yerelde çalıştırmak için:
#   pip install matplotlib numpy
#   python notebooks/01_amm_simulasyonu.py

import os, math
import numpy as np
import matplotlib.pyplot as plt

# Reponun kendi AMM sınıfını import etmiyoruz; formülü direkt kullanıyoruz ki
# state'e dokunmadan önizleme yapabilelim.
def preview_swap_x_for_y(x, y, fee, dx):
    k = x * y
    dx_eff = dx * (1 - fee)
    x_new = x + dx_eff
    y_new = k / x_new
    dy_out = y - y_new
    price_before = x / y
    price_after  = x_new / y_new
    effective_px = dx / dy_out
    impact_pct   = (price_after - price_before) / price_before * 100
    slip_pct     = (effective_px - price_before) / price_before * 100
    return dy_out, price_after, effective_px, impact_pct, slip_pct

def main():
    x0, y0, fee = 1000.0, 1000.0, 0.003
    price0 = x0 / y0

    dxs = np.linspace(1, 300, 60)
    impacts, slips, eff_prices = [], [], []

    for dx in dxs:
        _, p_after, eff_px, impact, slip = preview_swap_x_for_y(x0, y0, fee, dx)
        impacts.append(impact)
        slips.append(slip)
        eff_prices.append(eff_px)

    outdir = "docs/plots"
    os.makedirs(outdir, exist_ok=True)

    # Grafik 1: Impact vs dx
    plt.figure()
    plt.title("Price Impact (%) vs dx")
    plt.xlabel("dx")
    plt.ylabel("Impact (%)")
    plt.plot(dxs, impacts)
    plt.savefig(os.path.join(outdir, "impact_vs_dx.png"), bbox_inches="tight")

    # Grafik 2: Slippage vs dx
    plt.figure()
    plt.title("Slippage (%) vs dx")
    plt.xlabel("dx")
    plt.ylabel("Slippage (%)")
    plt.plot(dxs, slips)
    plt.savefig(os.path.join(outdir, "slippage_vs_dx.png"), bbox_inches="tight")

    # Grafik 3: Effective price vs dx (referans fiyat çizgisi ile)
    plt.figure()
    plt.title("Effective Price vs dx (ref price dotted)")
    plt.xlabel("dx")
    plt.ylabel("Price (X per 1 Y)")
    plt.plot(dxs, eff_prices)
    plt.axhline(price0, linestyle="--")
    plt.savefig(os.path.join(outdir, "effective_price_vs_dx.png"), bbox_inches="tight")

if __name__ == "__main__":
    main()
