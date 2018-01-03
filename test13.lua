-- Need Lua 5.3

---[[
-- 13.1: Write a function to compute the modulo operation for unsigned integers.

local function umod(n, d)
    if d < 0 then
        if math.ult(n, d) then return n
        else return n - d
        end
    end
    local q = ((n >> 1) // d) << 1
    local r = n - q * d
    if not math.ult(r, d) then
        return r - d
    else
        return r
    end
end

local x = 3 << 62
print(x)
print(string.format("%u", x))
local mod = umod(x >> 1, x+100)
print(string.format("%u", mod))

--]]


---[[
-- 13.2: Implement differnet ways to compute the number of bits in the representation of a Lua integer.

local function number_of_bits(x)
    local count = 0
    while x ~= 0 do
        count = count + 1
        x = x >> 1
    end
    return count
end

local x = 3 << 62
print("Number of bits:", number_of_bits(x))

--]]


---[[
-- 13.3: How can you test whether a given integer is a power of two?

local function power_of_two(x)
    return x > 0 and ((x & (x - 1)) == 0)
end

print("Is Power of two:", power_of_two(1 << 13))
print("Is Power of two:", power_of_two(((1 << 12) + 32)))

--]]


---[[
-- 13.4: Write a function to compute the Hamming weight of a given integer. (The Hamming weight of a number is the number of ones in its binary representation)

local function hamming_weight(x)
    local count = 0
    while x ~= 0 do
        if x & 1 > 0 then
            count = count + 1
        end
        x = x >> 1
    end
    return count
end

local function hamming_weight2(x)
    local count = 0
    while x ~= 0 do
        count = count + 1
        x = x & (x-1)
    end
    return count
end

local x = 900012345
print("Hamming_weight:", hamming_weight(x))
print("Hamming_weight:", hamming_weight2(x))

--]]


---[[
-- 13.5: Write a function to test whether the binary representation of a given integer is a palindrome

local function is_palindrome(x)
    local size = 64
    for i = 0, size/2 do
        if ((x >> i) & 1) ~= (((x << i) & (1 << (size-1))) >> size-1) then
            return false
        end
    end
    return true
end

local x = 0xFFFFFFFFFFFFFFFF
print("Is palindrome:", is_palindrome(x))
print("Is palindrome:", is_palindrome(0xFFFFFFFE7FFFFFFF))
print("Is palindrome:", is_palindrome(0xFFFFFFFE7FFFFFFE))

--]]


---[[
-- 13.6: Implement a bit array in Lua. It should support the following operations:
-- * newBitArray(n) (creates an array with n bits),
-- * setBit(a, n, v) (assigns the Boolean value v to bit n of array a),
-- * testBit(a, n) (returns a Boolean with the value of bit n).

local function newBitArray(n)
    local array = {}
    for i = 1, n do
        array[i] = 1
    end
    return array
end

local function setBit(a, n, v)
    a[n] = v and 1 or 0
end

local function testBit(a, n)
    return a[n] == 1 and true or false
end

local a = newBitArray(100)
setBit(a, 99, false)
print(testBit(a, 98))
print(testBit(a, 99))

--]]


---[[
-- 13.7: Suppose we have a binary file with a sequence of records, each one with the following format:
-- struct Record {
--     int x;
--     char[3] code;
--     float value;
-- };
-- Write a program that reads that file and prints the sum of the value fields.

-- local out = io.open("test13.bin", "wb")

-- for i = 1, 100 do
--     local x = math.random(999)
--     local b1 = math.random(0, 255)
--     local b2 = math.random(0, 255)
--     local b3 = math.random(0, 255)
--     local f = math.random()
--     local packStr = string.pack("iBBBf", x, b1, b2, b3, f)
--     out:write(packStr)
-- end
-- out:close()

local blocksize = #string.pack("iBBBf", 0, 0, 0, 0, 0)
print("blocksize:", blocksize)

local input = io.open("test13.bin", "rb")
local x, b1, b2, b3, f
local sum = 0
for bytes in input:lines(blocksize) do
    x, b1, b2, b3, f = string.unpack("iBBBf", bytes)
    print(x, b1, b2, b3, f)
    sum = sum + f
end
print("Sum of value:", sum)

input:close()

--]]
