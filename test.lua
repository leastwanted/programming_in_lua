print("123")

pwd = "11111111"

md5 = require("md5")
require("repr")

pwd = md5.sumhexa(pwd)
print(pwd)


-- print(string.char(123, 2, 1))

res = ""
tbl = {}

-- print(tonumber("ff", 16))

for i = 1, #pwd, 2 do
	res = res .. string.char(tonumber(pwd:sub(i, i+1):reverse(), 16))
end

-- print (string.format("%q", res))

-- for j = 1, 255 do
-- 	print(j)
-- 	-- print(string.char(j))
-- end

-- for k,v in ipairs(table) do
-- 	print(string.format("%q", v))
-- end

-- print(repr(res))

-- a = 513
-- b = math.floor(a/ 0x100)
-- c = a % 256

-- print(b)
-- print(c)

a = {
	ALIVE, PEOPLE,
}

print(a.ALIVE)

-- nils don't count
local list = {}
list[0] = nil
list[1] = nil
list[2] = 'item'

print(#list) -- 0
print(select('#', list)) -- 1