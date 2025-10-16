# 🧠 DeFi Playground

<p align="center">
  <img src="https://raw.githubusercontent.com/S7ra7/defi-playground/main/docs/banner.svg" width="800" alt="DeFi Playground Banner">
</p>

![Build Status](https://img.shields.io/github/actions/workflow/status/USERNAME/defi-playground/.github/workflows/ci.yml?branch=main&label=Build)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Python](https://img.shields.io/badge/Python-3.11%2B-green.svg)
![Tests](https://img.shields.io/badge/Tests-Pytest%20%E2%9C%93-brightgreen)
[![Docs](https://img.shields.io/badge/Docs-Overview-blue)](./docs/overview.md)

Eğitim amaçlı modüler bir **DeFi Simülasyon Laboratuvarı**.  
AMM, Lending, ZK, FHE ve Paralel İşleme prensiplerini sade Python örnekleriyle bir araya getirir.  
---
## 🚀 Özellikler

✅ **AMM (Automated Market Maker)** – likidite havuzu & slipaj hesaplama  
✅ **Lending Protocol** – teminat, borç ve likidasyon simülasyonu  
✅ **ZK Proofs (Zero Knowledge)** – bilgiyi ifşa etmeden doğrulama  
✅ **FHE (Fully Homomorphic Encryption)** – şifreli veri üzerinde işlem  
✅ **Parallel Processing** – batch işlemlerle verimlilik artırımı  
---
## 🧩 Modül Yapısı
---
## ⚙️ CI/CD Süreci

GitHub Actions ile her commit sonrası otomatik test akışı:
1. Ortam kurulumu (Python 3.11)  
2. Bağımlılık yükleme (`requirements.txt`)  
3. `pytest` test çalıştırma  
4. Sonuç raporu (yeşil: başarı, kırmızı: hata)

> **Amaç:** Her modülün tek başına çalışabilir ve test edilebilir olması.
---
## 🧠 Diyagram
flowchart TD
  A[AMM] --> B[Lending]
  B --> C[Parallel]
  A --> D[ZK Proofs]
  D --> E[FHE Privacy Layer]
  E --> F[DeFi Playground Results]
