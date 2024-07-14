end_hex = b"\x00\x00\x00\x00\x49\x45\x4e\x44\xae\x42\x60\x82"

with open('image.png', 'ab') as f:
     f.write(b'Hello world ! This is my secret !')


