# Fully Homomorphic Encryption (FHE) basitleştirilmiş örnek
# Bu sadece kavramsal bir simülasyondur, gerçek kripto değildir.

class SimpleFHE:
    def __init__(self, key: int):
        self.key = key

    def encrypt(self, value: int) -> int:
        """XOR tabanlı sahte şifreleme."""
        return value ^ self.key

    def decrypt(self, cipher: int) -> int:
        return cipher ^ self.key

    def add_encrypted(self, c1: int, c2: int) -> int:
        """Şifreli veriler üzerinde toplama (simülasyon)."""
        # Gerçekte FHE cebirsel homomorfizme dayanır.
        p1, p2 = self.decrypt(c1), self.decrypt(c2)
        return self.encrypt(p1 + p2)


def demo():
    fhe = SimpleFHE(key=42)
    c1 = fhe.encrypt(10)
    c2 = fhe.encrypt(20)
    c_sum = fhe.add_encrypted(c1, c2)
    return fhe.decrypt(c_sum)
