-- Chapter 20. Metatables and Metamethods

---[[
-- 20.1: Define a metamethod __sub for sets that returns the difference of two sets. (The set a - b is the set of elements from a that are not in b.)

local Set = {}
local mt = {}

function Set.new(l)
    local set = {}
    setmetatable(set, mt)
    for _, v in ipairs(l) do set[v] = true end
    return set
end

function Set.union(a, b)
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end

function Set.intersection(a, b)
    local res = Set.new{}
    for k in pairs(a) do 
        res[k] = b[k]
    end
    return res
end

function Set.tostring(set)
    local l = {}
    for e in pairs(set) do
        l[#l + 1] = tostring(e)
    end
    return "{"  .. table.concat(l, ", ") .. "}"
end

function Set.sub(a, b)
    local res = Set.new{}
    for k in pairs(a) do
        if not b[k] then
            res[k] = true
        end
    end
    return res
end

mt.__add = Set.union
mt.__mul = Set.intersection
mt.__tostring = Set.tostring
mt.__sub = Set.sub

local aSet = Set.new{1, 2, 3}
local bSet = Set.new{3, 4}
print(aSet + bSet)
print(aSet * bSet)
print(aSet - bSet)

--]]


---[[
-- 20.2: Define a metamethod __len for sets so that #s returns the number of elements in the set s.

function Set.len(set)
    local res = 0
    for k in pairs(set) do
        res = res + 1
    end
    return res
end

mt.__len = Set.len

print(#aSet)
print(#(aSet + bSet))

--]]


---[[
-- 20.3: An alternative way to implement read-only tables might use a function as the __index metamethod. This alternative makes accesses more expensive, but the creation of read-only tables is cheaper, as all read-only tables can share a single metatable. Rewrite the function readOnly using this approach.

local proxytable = {}
local mt = {
    __index = function (t, k)
        return proxytable[t][k]
    end,
    __newindex = function (t, k, v)
        error("attempt to update a read-only table", 2)
    end
}

function readOnly(t)
    local proxy = {}
    proxytable[proxy] = t
    setmetatable(proxy, mt)
    return proxy
end

days = readOnly{"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
print(days[1])
-- days[2] = "Noday"
print(days[2])

--]]


---[[
-- 20.4: Proxy tables can represent other kinds of objects besides tables. file as array Write a function fileAsArray that takes the name of a file and returns a proxy to that file, so that after a call t = fileAsArray("myFile"), an access to t[i] returns the i-th byte of that file, and an assignment to t[i] updates its i-th byte.

function fileAsArray(filename)
    local proxy = {}
    local mt = {
        __index = function (t, k)
            local f = io.open(filename, "r")
            f:seek("set", k-1)
            local s = f:read(1)
            f:close()
            return s
        end,
        __newindex = function (t, k, v)
            local f = io.open(filename, "r+")
            f:seek("set", k-1)
            f:write(v)
            f:close()
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

t = fileAsArray('test20.bytes')
for i = 1, 20 do
    t[i] = string.char(70)
end
print(t[1])
print(t[3])
t[15] = 'a'
print(t[15])

--]]


---[[
-- 20.5: Extend the previous example to allow us to traverse the bytes in the file with pairs(t) and get the file length with #t.

function fileAsArray(filename)
    local proxy = {}
    local mt = {
        __index = function (t, k)
            local f = io.open(filename, "r")
            f:seek("set", k-1)
            local s = f:read(1)
            f:close()
            return s
        end,
        __newindex = function (t, k, v)
            local f = io.open(filename, "r+")
            f:seek("set", k-1)
            f:write(v)
            f:close()
        end,
        __pairs = function ()
            local f = io.open(filename, "r")
            local size = f:seek("end")
            f:seek("set", 0)
            return function (_, k)
                k = k or 0
                if k == size then
                    f:close()
                    return nil
                end
                return k + 1, f:read(1)
            end
        end,
        __len = function ()
            local f = io.open(filename, "r")
            local size = f:seek("end")
            f:close()
            return size
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

t = fileAsArray('test20.bytes')

print(#t)

for k, v in pairs(t) do
    print(k, v)
end

--]]
