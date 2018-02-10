-- Chapter 3. Numbers

---[[
-- 3.1: Which of the following are valid numerals? What are their values?
-- .0e12 .e12 0.0e 0x12 0xABFG 0xA FFFF 0xFFFFFFFF 0x 0x1P10 0.1e1 0x0.1p1

print("--- 3.1 ---")

print(.0e12)

-- print(.e12)

-- print(0.0e)

print(0x12)

-- print(0xABFG)

print(0xA)

-- print(FFFF)

print(0xFFFFFFFF)

-- print(0x)

print(0x1P10)

print(0.1e1)

print(0x0.1p1)

--]]


---[[
-- 3.2: Explain the following results:

-- math.maxinteger * 2
-- math.mininteger * 2
-- math.maxinteger * math.maxinteger
-- math.mininteger * math.mininteger

-- (Remember that integer arithmetic always wraps around.)

print("\n--- 3.2 ---")

print(math.maxinteger * 2)
print(math.mininteger * 2)
print(math.maxinteger * math.maxinteger)
print(math.mininteger * math.mininteger)

--]]


---[[
-- 3.3: What will the following program print?

-- for i = -10, 10 do
--     print(i, i % 3)
-- end

print("\n--- 3.3 ---")

for i = -10, 10 do
    print(i, i % 3)
end

--]]


---[[
-- 3.4: What is the result of the expression 2^3^4? What about 2^-3^4?

print("\n--- 3.4 ---")

print(2^3^4)
print(2^-3^4)

--]]


---[[
-- 3.5: The number 12.7 is equal to the fraction 127/10, where the denominator is a power of ten. Can you express it as a common fraction where the denominator is a power of two? What about the number 5.5?

-- 12.7 can not beexpressed as power of two

-- 5.5 = 11 / 2

--]]


---[[
-- 3.6: Write a function to compute the volume of a right circular cone, given its height and the angle between a generatrix and the axis.

function calc_cone(h, a)
    local r = math.tan(math.rad(a)) * h
    return math.pi * r * r * h / 3
end

print("\n--- 3.6 ---")
print(calc_cone(1, 45))

--]]


---[[
-- 3.7: Using math.random, write a function to produce a pseudo-random number with a standard normal(Gaussian) distribution.

function normal(mu, sigma)
    mu = mu or 0
    sigma = sigma or 1
    local z0 = math.sqrt(-2.0 * math.log(math.random())) * math.cos(math.pi * 2.0 * math.random())
    return z0 * sigma + mu

end

print("\n--- 3.7 ---")
for i = 1, 10 do
    print(normal())
end

--]]
