-- Chapter 4. Strings

---[[
-- 4.1: How can you embed the following fragment of XML as a string in a Lua program?

-- <![CDATA[
--  Hello world
-- ]]>

s = [=[<![CDATA[
    Hello world
]]>]=]

print("--- 4.1 ---")
print(s)

--]]


---[[
-- 4.2: Suppose you need to write a long sequence of arbitary bytes as literal string in Lua. What format would you use? Consider issues like readability, maximum line length, and size.

data = "\x00\x01\x02\x03\x04\x05\x06\x07\z
        \x08\x09\x0A\x0B\x0C\x0D\x0E\x0F"

print("\n--- 4.2 ---")
print(data)
print(string.len(data))

--]]


---[[
-- 4.3: Write a function to insert a string into a given position of another one:

function insert(s1, pos, s2)
    return s1:sub(1, pos-1) .. s2 .. s1:sub(pos, -1)
end

print("\n--- 4.3 ---")
print(insert("hello world", 1, "start: "))
print(insert("hello world", 7, "small "))

--]]


---[[
-- 4.5: Write a function to remove a slice from a string; the slice should be given by its initial position and its length:

function remove(s, pos, len)
    return s:sub(1, pos-1) .. s:sub(pos+len, -1)
end

print("\n--- 4.5 ---")
print(remove("hello world", 7, 4))

--]]

---[[
-- 4.7: Write a function to check whether a given string is a palindrome:

function ispali(s)
    for i = 1, #s/2 do
        if s:sub(i, i) ~= s:sub(-i, -i) then
            return false
        end
    end
    return true
end

print("\n--- 4.7 ---")
print(ispali("step on no pets"))
print(ispali("banana"))

--]]


---[[
-- 4.8: Redo the previous exercise so that it ignores differences in spaces and punctuation.

function filterstr(s, m)
    return s:gsub(m, "")
end

function ispali2(s)
    s = s:gsub("%s", ""):gsub("%p", "")
    return ispali(s)
end

print("\n--- 4.8 ---")
-- print(filterstr("test   test test", "%s"))
print(ispali2("step    on,,, no   pets"))

--]]
