-- Chapter 10. Pattern Matching

---[[ 
-- 10.1: Write a function split that receives a string and a delimiter pattern and returns a sequence with the chunks in the original string separated by the delimiter:

-- t = split("a whole new world", " ")
-- -- t = {"a", "whole", "new", "world"}

-- How does your function handle empty strings? (In particular, is an empty string an empty sequence or a sequence with one empty string?)

function split(s, d)
    local words = {}
    d = string.gsub(d, "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
    print (d)
    for w in string.gmatch(s, "[^" .. d .. "]+") do
        table.insert(words, w)
    end
    return words
end

print("--- 10.1 ---")
t = split("a%whole%new%%world", "%%")

for _, v in ipairs(t) do print(v) end

--]]


---[[
-- 10.2: The patterns '%D' and '[^%d]' are equivalent. What about the patterns '[^%d%u]' and '[%D%U]'?

print("\n--- 10.2 ---")

p1 = "%d"  -- digits
p2 = "%D"  -- not digits
p3 = "%u"  -- upper-case letters
p4 = "%U"  -- not upper-case letters

p5 = '[^%d%u]+'  -- not (digits and upper-case letters)

print(string.match("abcdefGH1IJ", p5))

p6 = '[%D%U]+'  -- not digits or not upper-case letters

print(string.match("ABCDEFG123456abcdefg", p6))

--]]


---[[
-- 10.3:Write a function transliterate. This function receives a string and replaces each character in that string with another character, according to a table given as a second argument. If the table maps a to b, the function should replace any occurrence of a with b. If the table maps a to false, the function should remove occurrences of a from the resulting string.

function transliterate(s, t)
    return (string.gsub(s, ".", function(c)
        return t[c] and tostring(t[c]) or ""
    end))
end

print("\n--- 10.3 ---")
print(transliterate("abcdefg12345", {a=1,b=2,c=3}))

--]]


---[[
-- 10.4: At the end of the section called “Captures”, we defined a trim function. Because of its use of backtracking, this function can take a quadratic time for some strings. (For instance, in my new machine, a match for a 100 KB string can take 52 seconds.)
-- • Create a string that triggers this quadratic behavior in function trim.
-- • Rewrite that function so that it always works in linear time

print("\n--- 10.4 ---")

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


---[[
-- 10.5:  Write a function to format a binary string as a literal in Lua, using the escape sequence \x for all bytes:

-- print(escape("\0\1hello\200"))
-- --> \x00\x01\x68\x65\x6C\x6C\x6F\xC8

-- As an improved version, use also the escape sequence \z to break long lines.

function escape(s)
    return (string.gsub(s, ".", function(c)
        return string.format("\\x%02X", string.byte(c))
    end))
end

print("\n--- 10.5 ---")
print(escape("\0\1hello\200"))

--]]


---[[
-- 10.6: Rewrite the function transliterate for UTF-8 characters.

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

print("\n--- 10.6 ---")
print(transliterate("尼玛比亚", {["尼"]=1,["玛"]=2,c=3}))

--]]


---[[
-- 10.7: Write a function to reverse a UTF-8 string.

utf8charpattern = "([%z\1-\127\194-\244][\128-\191]*)"

function reverse(s)
    words = {}
    for w in string.gmatch(s, utf8charpattern) do
        table.insert(words, 1, w)
    end
    return table.concat(words)
end

print("\n--- 10.7 ---")
print(reverse("尼玛比亚"))

--]]
