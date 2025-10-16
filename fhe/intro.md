# Fully Homomorphic Encryption (FHE)

FHE, veriyi şifreli halde tutarken onun üzerinde **doğrudan işlem yapmayı** mümkün kılar.  
Yani veriyi çözmeden toplama, çarpma gibi matematiksel işlemler yapılabilir.

## Temel fikir
Normal şifreleme:  
> Encrypt(x) → cipher_x  
> Decrypt(cipher_x) = x  

FHE:  
> Encrypt(x) → cipher_x  
> Encrypt(y) → cipher_y  
> Compute(cipher_x ⊕ cipher_y) → cipher_z  
> Decrypt(cipher_z) = x + y  ✅  

Bu sayede bir bulut servisi, kullanıcının verisini hiç görmeden hesaplama yapabilir.

### Kullanım alanları
- Gizlilik odaklı DeFi protokolleri (ör. FHE-swap, gizli limit emirleri)  
- Sağlık ve finans verilerinde güvenli istatistik  
- Yapay zekâ modellerinde gizli veriyle tahmin

### Kavramsal fark:
| Özellik | Geleneksel Şifreleme | FHE |
|----------|----------------------|-----|
| Şifreli veride işlem | ❌ | ✅ |
| Hesaplama hızı | Çok hızlı | Yavaş (ama gelişiyor) |
| Gizlilik seviyesi | Orta | Çok yüksek |

# Fully Homomorphic Encryption (FHE)

FHE, veriyi şifre çözmeden **üzerinde işlem yapmaya** izin verir.
Örnek: x ve y şifreli haldeyken toplama yapılır, sonuç çözüldüğünde x+y elde edilir.

## Kullanım alanları
- Gizli emir/pozisyon içeren DeFi tasarımları
- Sağlık/finans verilerinde gizlilik
- ML modellerinde gizli veriyle tahmin

> Not: Gerçek FHE kütüphaneleri (BFV/CKKS vb.) ağırdır; bu repo eğitim amaçlıdır.
