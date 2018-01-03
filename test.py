import md5

pwd = "11111111"

pwd = md5.md5(pwd).hexdigest()

print(repr(pwd))
ret = ""
for i in range(0, len(pwd), 2):
	ret += chr(int(pwd[i+1] + pwd[i], 16))

print repr(ret)

for i in range(256):
	print(chr(i)),