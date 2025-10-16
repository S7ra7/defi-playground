# DeFi Playground - Genel Bakış

Bu proje, farklı DeFi protokollerinin temel mekanizmalarını **eğitim amaçlı** olarak bir araya getirir.  
Her modül kendi testleriyle CI üzerinden otomatik kontrol edilir.

---

## 🧩 Modül Özeti

| Modül | Açıklama | Dosya Konumu |
|--------|-----------|---------------|
| **AMM (Automated Market Maker)** | Likidite havuzu fiyatlaması ve slipaj hesaplamaları. | `amm/` |
| **Lending** | Teminat, borç, likidasyon hesapları. | `lending/` |
| **Parallel** | Paralel işlem benzetimi, batch fonksiyonları. | `parallel/` |
| **ZK (Zero Knowledge)** | Bilgiyi ifşa etmeden doğrulama prensibi. | `zk/` |
| **FHE (Fully Homomorphic Encryption)** | Şifrelenmiş veriler üzerinde işlem yapılabilmesini gösterir. | `fhe/` |

---

## ⚙️ CI/CD İş Akışı

Her commit’te GitHub Actions otomatik olarak şunları yapar:
1. Python ortamı kurulur  
2. Gerekli bağımlılıklar (`requirements.txt`) yüklenir  
3. `pytest` testleri tüm modüller için çalıştırılır  
4. Sonuçlar **Actions** sekmesinde raporlanır

---

## 🧠 Basitleştirilmiş Yapı Diyagramı (Mermaid)

```mermaid
flowchart TD
    A[AMM] --> B[Lending]
    B --> C[Parallel]
    A --> D[ZK Proofs]
    D --> E[FHE Privacy Layer]
    E --> F[DeFi Playground Results]
