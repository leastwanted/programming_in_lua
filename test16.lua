-- Chapter 16. Compilation, Execution, and Errors

---[[
-- 16.1: Frequently, it is useful to add some prefix to a chunk of code when loading it. (We saw an example previously in this chapter, where we prefixed a return to an expression being loaded.) Write a function loadwithprefix that works like load, except that it adds its extra first argument (a string) as a prefix to the chunk being loaded.

-- Like the original load, loadwithprefix should accept chunks represented both as strings and as reader functions. Even in the case that the original chunk is a string, loadwithprefix should not actually concatenate the prefix with the chunk. Instead, it should call load with a proper reader function that first returns the prefix and the returns the original chunk.

function loadwithprefix(chunk, prefix)
    -- local t = {}
    -- table.insert(t, prefix)
    if type(chunk) == "function" then
        local function read()
            if prefix then
                local res = prefix
                prefix = nil
                return res
            end
            return chunk()
        end
        return load(read)
    else
        return load(prefix .. chunk)
    end
end

print("--- 16.1 ---")

a = loadwithprefix("1", "return ")()
print(a)

loadwithprefix(io.lines("lib16.lua"), "x = 2")()

--]]


---[[
-- 16.2: Write a function multiload that generalizes loadwithprefix by receiving a list of readers, as in the following example:

-- f = multiload("local x = 10;", io.lines("temp", "*L"), " print(x)")

-- In the above example, multiload should load a chunk equivalent to the concatenation of the string "local...", the contents of the temp file, and the string "print(x)". Like loadwithprefix, from the previous exercise, multiload should not actually concatenate anything.

function multiload( ... )
    local t = {...}
    local function read()
        local head = t[1]
        while head do
            if type(head) == "string" then
                table.remove(t, 1)
                return head
            else
                local res = head()
                if res then
                    return res
                end
                table.remove(t, 1)
            end
            head = t[1]
        end
    end
    return load(read)
end

print("\n--- 16.2 ---")

f = multiload("local x = 10;", io.lines("lib16.lua", "*L"), " print(x)")
f()

--]]


---[[
-- 16.3: The function stringrep, in Figure 16.2, "String repetition", uses a binary multiplication algorithm to concatenate n copies of a given string s.

function stringrep (s, n)
    local r = ""
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then r = r .. s end
            s = s .. s
            n = math.floor(n / 2)
        end
        r = r .. s
    end
    return r
end

-- For any fixed n, we can create a specialized version of stringrep by unrolling the loop into a sequence of instructions r = r .. s and s = s .. s. As an example, for n = 5 the unrolling gives us the following function:

function stringrep_5(s)
    local r = ""
    r = r .. s
    s = s .. s
    s = s .. s
    r = r .. s
    return r
end

-- Write a function that, give n, returns a specialized function stringrep_n. Instead of using a closure, your function should build the text of a Lua function with the proper sequence of instructions (a mix of r = r .. s and s = s .. s) and then use load to produce the final function. Compare the performance of the generic function stringrep (or of a closure using it) with your tailor-made functions.

function make_stringrep(n)
    local t = {}
    table.insert(t, "local s = ...")
    table.insert(t, "local r = ''")
    if n > 0 then
        while n > 1 do
            if n % 2 ~= 0 then
                table.insert(t, "r = r .. s")
            end
            table.insert(t, "s = s .. s")
            n = math.floor(n / 2)
        end
        table.insert(t, "r = r .. s")
    end
    table.insert(t, "return r")
    return load(table.concat(t, "\n"))
end

print("\n--- 16.3 ---")

n = 99999999
f = make_stringrep(n)
do
    local t = os.clock()
    f("abc")
    print(string.format("time spent: %f", os.clock() - t))
end

do
    local t = os.clock()
    stringrep("abc", n)
    print(string.format("time spent: %f", os.clock() - t))
end

--]]


---[[
-- 16.4: Can you find any value for f such that the call pcall(pcall, f) returns false as its first result? Why is this relevant?

-- Answer from https://stackoverflow.com/questions/39113323/how-do-i-find-an-f-that-makes-pcallpcall-f-return-false-in-lua

print("\n--- 16.4 ---")

status, err = pcall(pcall, (function() end)())
print(status, err)

--]]
