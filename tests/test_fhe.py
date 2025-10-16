from fhe.fhe_demo import SimpleFHE, demo

def test_fhe_addition_demo():
    result = demo()
    assert result == 30  # 10 + 20

def test_encrypt_decrypt():
    fhe = SimpleFHE(99)
    val = 123
    cipher = fhe.encrypt(val)
    plain = fhe.decrypt(cipher)
    assert plain == val
