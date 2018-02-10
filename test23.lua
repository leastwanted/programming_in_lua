-- Chapter23. Garbage

---[[
-- 23.1: Write an experiment to determine whether Lua actually implements ephemeron tables. (Remever to call collectgarbage to force a garbage collection cycle.) If possible, try your code both in Lua 5.1 and in Lua 5.2/5.3 to see the difference.

do
    local mem = {} -- memorization table
    setmetatable(mem, {__mode = "k"})
    function factory (o)
        local res = mem[o]
        if not res then
            res = (function () return o end)
            mem[o] = res
        end
        return res
    end

    function print_mem( ... )
        for k, v in pairs(mem) do
            print(k, v)
        end
    end
end

local a = {}
factory(a)()
factory({})
a = nil

print_mem()
collectgarbage()
print("-----")
print_mem()

--]]


---[[
-- 23.2: Consider the first example of the section called "Finalizers", which creates a table with a finalizer that only prints a message when activated. What happens if the program ends without a collection cycle? What happens if the program calls os.exit? What happens if the program ends with an error?

o = {x = "hi"}
setmetatable(o, {__gc = function (o) print(o.x) end})
o = nil
collectgarbage()
-- os.exit()
-- error("error exit")

--]]


---[[
-- 23.3: Imagine you have to implement a memorizing table for a function from strings to strings. Making the table weak will not do the removal of entries, because weak tables do not consider strings as collectable objects. How can you implement memorization in that case?

do
    local mem = {} -- memorization table
    setmetatable(mem, {__mode = "v"})
    function factory_string (s)
        local res = mem[s]
        if not res then
            res = (function () return s .. "!" end)
            mem[s] = res
        end
        return res
    end

    function print_mem_string( ... )
        for k, v in pairs(mem) do
            print(k, v)
        end
    end
end

local a = factory_string("hello")
print(a())
print(factory_string("world")())

print_mem_string()
collectgarbage()
print("-----")
print_mem_string()

--]]


---[[
-- 23.4: Finalizers and memory

local count = 0

local mt = {__gc = function () count = count -1 end}
local a = {}

for i = 1, 10000 do
    count = count + 1
    a[i] = setmetatable({}, mt)
end

collectgarbage()
print(collectgarbage("count") * 1024, count)
a = nil
collectgarbage()
print(collectgarbage("count") * 1024, count)
collectgarbage()
print(collectgarbage("count") * 1024, count)

--]]


---[[
-- 23.5: For this exercise, you need at least one Lua script that uses lots of memory. If you do not have one, write it. (It can be as simple as a loop creating tables.)

-- Run your script with different values for pause and stepmul. How they affect the performance and memory usage of the script? What happens if you set the pause to zero? What happens if you set the pause to 1000? What happens if you set the step multiplier to zero? What happens if you set the step multiplier to 1000000?

local t = os.clock()
dofile("test23-mem.lua")
print(string.format("normal: %f", os.clock() - t))

collectgarbage("setpause", 0)
local t = os.clock()
dofile("test23-mem.lua")
print(string.format("pause(0): %f", os.clock() - t))

collectgarbage("setpause", 1000)
local t = os.clock()
dofile("test23-mem.lua")
print(string.format("pause(1000): %f", os.clock() - t))

collectgarbage("setstepmul", 0)
local t = os.clock()
dofile("test23-mem.lua")
print(string.format("stepmul(0): %f", os.clock() - t))

collectgarbage("setstepmul", 1000000)
local t = os.clock()
dofile("test23-mem.lua")
print(string.format("stepmul(1000000): %f", os.clock() - t))

-- Adapt your script so that it keeps full control over the garbage collector. It should keep the collector stopped and call it from time to time to do some work. Can you improve the performance of your script with this approach?

collectgarbage("stop")
local t = os.clock()
dofile("test23-mem.lua")
print(string.format("gc stopped: %f", os.clock() - t))
collectgarbage("restart")

--]]
