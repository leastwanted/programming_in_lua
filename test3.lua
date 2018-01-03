print(math.sin(math.pi / 2))

math.randomseed(os.time())

print(math.random())

print(math.random(6))

print(math.random(10, 20))

print(math.modf(3.3))

print(math.maxinteger)

-- print(math.type(1)) -- not supported in lua 5.1

-- math.tointeger(-2.5)

-- 3.1

-- a = 0x0.1p1

print(a)


-- 3.2

-- 3.3

for i = -10, 10 do
	print(i, i % 3)
end

-- 3.4

print(2^3^4)

print(2^-3^4)
print(2^(-3^4))

-- 3.5


-- 3.6

function calc_cone(h, a)
	local r = math.tan(a) * h
	return math.pi * r * r * h / 3
end