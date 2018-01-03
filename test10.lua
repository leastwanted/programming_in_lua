--[[ 
-- 10.1

function split(s, d)
    local words = {}
    d = string.gsub(d, "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
    print (d)
    for w in string.gmatch(s, "[^" .. d .. "]+") do
        table.insert(words, w)
    end
    return words
end

t = split("a%whole%new%%world", "%%")

for _, v in ipairs(t) do print(v) end

--]]


--[[
-- 10.2

p1 = "%d"  -- digits
p2 = "%D"  -- not digits
p3 = "%u"  -- upper-case letters
p4 = "%U"  -- not upper-case letters

p5 = '[^%d%u]+'  -- not (digits and upper-case letters)

print(string.match("abcdefGH1IJ", p5))

p6 = '[%D%U]+'  -- not digits or not upper-case letters

print(string.match("ABCDEFG123456abcdefg", p6))

--]]


--[[
-- 10.3

function transliterate(s, t)
    return (string.gsub(s, ".", function(c)
        return t[c] and tostring(t[c]) or ""
    end))
end

print(transliterate("abcdefg12345", {a=1,b=2,c=3}))

--]]


--[[
-- 10.4

f = io.open("test10.txt", "w")

for i = 1, 10000000 do
    x = math.random(1, 125)
    -- f:write(string.char(x))
    f:write("1")
end

-- f:write("1")

-- for i = 1, 10000000 do
--     x = math.random(1, 125)
--     -- f:write(string.char(x))
--     f:write(" ")
-- end

-- f:close()

function trim(s)
    s = string.gsub(s, "^%s*(.-)%s*$", "%1")
    return s
end

ss = io.open("test10.txt", "r"):read('*all')

t = os.clock()
trim(ss)
print(string.format("time spent: %f", os.clock() - t))

function trim2(s)
    s = string.gsub(s, "^%s*", "")
    s = string.gsub(s, "%s*$", "")
    return s
end

ss = io.open("test10.txt", "r"):read('*all')

t = os.clock()
trim2(ss)
print(string.format("time spent: %f", os.clock() - t))
--]]


--[[
-- 10.5

function escape(s)
    return (string.gsub(s, ".", function(c)
        return string.format("\\x%02X", string.byte(c))
    end))
end

print(escape("\0\1hello\200"))

--]]


--[[
-- 10.6
-- utf8charpattern = '[\0-\x7F\xC2-\xF4][\x80-\xBF]*'
-- utf8charpattern = '[\0-\127\194-\244][\128-\191]*'
utf8charpattern = "([%z\1-\127\194-\244][\128-\191]*)"

-- for w in string.gmatch("尼玛比亚", utf8charpattern) do
--     print(w)
-- end

-- print(string.match("sdfdsf", utf8charpattern))

function transliterate(s, t)
    return (string.gsub(s, utf8charpattern, function(c)
        return t[c] and tostring(t[c]) or ""
    end))
end

print(transliterate("尼玛比亚", {["尼"]=1,["玛"]=2,c=3}))

--]]


--[[
-- 10.7
utf8charpattern = "([%z\1-\127\194-\244][\128-\191]*)"

function reverse(s)
    words = {}
    for w in string.gmatch(s, utf8charpattern) do
        table.insert(words, 1, w)
    end
    return table.concat(words)
end

print(reverse("尼玛比亚"))

--]]
