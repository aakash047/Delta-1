import random
import math


def is_prime(n):
    if n % 2 == 0:
        return False
    for i in range(2, n // 2 + 1):
        if n % i == 0:
            return False
    return True


def generate_prime(min_value, max_value):
    prime = random.randint(min_value, max_value)
    while not is_prime(prime):
        prime = random.randint(min_value, max_value)
    return prime


def mod_inverse(e, phi):
    for d in range(2, phi):
        if (d * e) % phi == 1:
            return d
    raise ValueError("Inverse does not exist")


def generate_keys(p, q):
    n = p * q
    phi = (p - 1) * (q - 1)

    e = random.randint(2, phi)
    while math.gcd(e, phi) != 1:
        e = random.randint(2, phi)
    d = mod_inverse(e, phi)
    return ((e, n), (d, n))


def encrypt(pk, plaintext):
    key, n = pk
    cipher = [pow(ord(ch), key, n) for ch in plaintext]
    return cipher


def decrypt(pk, ciphertext):
    key, n = pk
    plain = [chr(pow(ch, key, n)) for ch in ciphertext]
    return "".join(plain)


def signing(private_key, message):
    return encrypt(private_key, message)


def verify(public_key, signed_message):
    return decrypt(public_key, signed_message)


p, q = generate_prime(1000, 5000), generate_prime(1000, 5000)
while p == q:
    q = generate_prime(1000, 5000)

public_key, private_key = generate_keys(p, q)
message = "Hello world"


# encoding using public key
encrypted_message = encrypt(public_key, message)
print("Encrypted message: ", encrypted_message)

# decoding using private key
decrypted_message = decrypt(private_key, encrypted_message)
print("Decrypted message: ", decrypted_message)

# signing in private and verifying in public
message_sign = "if it works then the message is signed and verified"
print("Message to be signed: ", message_sign)
signature = signing(private_key, message_sign)
print("Signature: ", signature)
verified_message = verify(public_key, signature)
print("Verified message: ", verified_message)







