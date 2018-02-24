-- Chapter 25. Reflection

---[[
-- 25.1: Adapt getvarvalue (Figure 25.1, "Getting the value of a variable") to work with different coroutines (like the functions from the debug library)

function getvarvalue (...)
    local co, name, level, isenv
    name, level, isenv = ...
    if type(name) ~= "string" then
        co, name, level, isenv = ...
    end
    print(co, name, level, isenv)
    local value
    local found = false
    if co then
        level = level or 1
    else
        level = (level or 1) + 1
    end

    -- try local variables
    for i = 1, math.huge do
        local n, v
        if co then
            n, v = debug.getlocal(co, level, i)
        else
            n, v = debug.getlocal(level, i)
        end
        if not n then break end
        if n == name then
            value = v
            found = true
        end
    end
    if found then return "local", value end

    -- try non-local variables
    local func
    if co then
        func = debug.getinfo(co, level, "f").func
    else
        func = debug.getinfo(level, "f").func
    end
    for i = 1, math.huge do
        local n, v
        if co then
            n, v = debug.getupvalue(co, func, i)
        else
            n, v = debug.getupvalue(func, i)
        end
        if not n then break end
        if n == name then return "upvalue", v end
    end
    if isenv then return "noenv" end -- avoid loop

    -- not found; get value from the environment
    local env
    if co then
        _, env = getvarvalue(co, "_ENV", level, true)
    else
        _, env = getvarvalue("_ENV", level, true)
    end
    if env then
        return "global", env[name]
    else -- no _ENV available
        return "noenv"
    end
end

print("--- 25.1 ---")
local a = 4
print(getvarvalue("a"))
b = "xx"
print(getvarvalue("b"))

co = coroutine.create(function ()
    local x = 10
    coroutine.yield()
    error("some error")
end)
coroutine.resume(co)
print(getvarvalue(co, "x"))

--]]


---[[
-- 25.2: Write a function setvarvalue similar to getvarvalue (Figure 25.1, “Getting the value of a variable”).

function setvarvalue (name, newval, level, isenv)
    local value
    local found = false
    level = (level or 1) + 1

    -- try local variables
    for i = 1, math.huge do
        local n, v = debug.getlocal(level, i)
        if not n then break end
        if n == name then
            value = v
            found = true
            debug.setlocal(level, i, newval)
        end
    end
    if found then
        return "local", value
    end

    -- try non-local variables
    local func = debug.getinfo(level, "f").func
    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        if n == name then
            debug.setupvalue(func, i, newval)
            return "upvalue", v
        end
    end
    if isenv then return "noenv" end -- avoid loop

    -- not found; get value from the environment
    local _, env = getvarvalue("_ENV", level, true)
    if env then
        env[name] = newval
        return "global", env[name]
    else -- no _ENV available
        return "noenv"
    end
end

print("\n--- 25.2 ---")
local a = 4
setvarvalue("a", 1)
print(a)
b = "xx"
setvarvalue("b", "haha")
print(b)

--]]


---[[
-- 25.3: Write a version of getvarvalue (Figure 25.1, “Getting the value of a variable”) that returns a table with all variables that are visible at the calling function. (The returned table should not include environmental variables; instead, it should inherit them from the original environment.)

function getvars (level)
    local res = {}
    level = (level or 1) + 1

    -- try local variables
    for i = 1, math.huge do
        local n, v = debug.getlocal(level, i)
        if not n then break end
        res[n] = v
    end

    -- try non-local variables
    local func = debug.getinfo(level, "f").func
    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        res[n] = v
    end

    return res
end

print("\n--- 25.3 ---")
for k, v in pairs(getvars()) do
    print(k, v)
end

--]]


---[[
-- 25.4: Write an improved version of debug.debug that runs the given commands as if they were in the lexical scope of the calling function. (Hint: run the commands in an empty environment and use the __index metamethod attached to the function getvarvalue to do all accesses to variables.)

function getvarvalue (name, level, isenv)
    local value
    local found = false
    level = (level or 1) + 1

    -- try local variables
    for i = 1, math.huge do
        local n, v = debug.getlocal(level, i)
        if not n then break end
        if n == name then
            value = v
            found = true
        end
    end
    if found then
        return value
    end

    -- try non-local variables
    local func = debug.getinfo(level, "f").func
    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        if n == name then
            debug.setupvalue(func, i, newval)
            return v
        end
    end
    if isenv then return nil end -- avoid loop
end

function debug1 ()
    local M = {print=print}
    setmetatable(M, {__index = function (t, n) return getvarvalue(n) end})
    while true do
        io.write("debug> ")
        local line = io.read()
        if line == "cont" then break end
        f = assert(load(line))
        debug.setupvalue(f, 1, M)
        f()
    end
end

print("\n--- 25.4 ---")
-- debug1()

--]]


---[[
-- 25.5: Improve the previous exercise to handle updates, too.

print("\n--- 25.5 ---")

--]]


---[[
-- 25.6: Implement some of the suggested improvements for the basic profiler that we developed in the section called “Profiles”.

print("\n--- 25.6 ---")

local Counters = {}
local Names = {}

local function hook ()
    local f = debug.getinfo(2, "f").func
    local count = Counters[f]
    if count == nil then -- first time 'f' is called?
        Counters[f] = 1
        Names[f] = debug.getinfo(2, "Sn")
    else -- only increment the counter
        Counters[f] = count + 1
    end
end

local f = assert(loadfile("test25-6.lua"))
debug.sethook(hook, "c") -- turn on the hook for calls
f() -- run the main program
debug.sethook() -- turn off the hook

function getname (func)
    local n = Names[func]
    if n.what == "C" then
        return n.name
    end
    local lc = string.format("[%s]:%d", n.short_src, n.linedefined)
    if n.what ~= "main" and n.namewhat ~= "" then
        return string.format("%s (%s)", lc, n.name)
    else
        return lc
    end
end

local sorted = {}
for func, count in pairs(Counters) do
    sorted[#sorted+1] = func
end
table.sort(sorted, function(a, b) return Counters[a] > Counters[b] end)

for _, f in ipairs(sorted) do
    local name = getname(f)
    name = name .. string.rep(" ", 30 - #name)
    if Counters[f] > 0 then
        print(name, Counters[f])
    end
end

--]]


---[[
--  25.7: Write a library for breakpoints. It should offer at least two functions:

-- setbreakpoint(function, line) --> returns handle
-- removebreakpoint(handle)

-- We specify a breakpoint by a function and a line inside that function. When the program hits a breakpoint, the library should call debug.debug. (Hint: for a basic implementation, use a line hook that checks whether it is in a breakpoint; to improve performance, use a call hook to trace program execution and only turn on the line hook when the program is running the target function.)

print("\n--- 25.7 ---")

local breakpoints = {}

function setbreakpoint(func, line)
    local handle = {}
    breakpoints[handle] = {func, debug.getinfo(func).linedefined + line}
    return handle
end

function removebreakpoint(handle)
    breakpoints[handle] = nil
end

function checkbreakpoint(func, line)
    for _, v in pairs(breakpoints) do
        if line == nil and v[1] == func then
            return true
        elseif v[1] == func and v[2] == line then
            return true
        end
    end
    return false
end

function breakpoint_hook(event, line)
    local func = debug.getinfo(2, "f").func

    if event == "call" then
        if checkbreakpoint(func) then
            debug.sethook(breakpoint_hook, "crl")
        else
            debug.sethook(breakpoint_hook, "cr")
        end

    elseif event == "line" then
        if checkbreakpoint(func, line) then
            debug.debug()
        end

    elseif event == "return" then
        func = debug.getinfo(3, "f") and debug.getinfo(3, "f").func
        if checkbreakpoint(func) then
            debug.sethook(breakpoint_hook, "crl")
        else
            debug.sethook(breakpoint_hook, "cr")
        end
    end
end

debug.sethook(breakpoint_hook, "cr")

function testfunc( ... )
    local a = 1
    local b = 2
    print(a)
    print(b)
end

-- handle = setbreakpoint(testfunc, 4)
-- testfunc()
-- removebreakpoint(handle)
-- testfunc()

debug.sethook()

--]]


---[[
-- 25.8: One problem with the sandbox in Figure 25.6, “Using hooks to bar calls to unauthorized functions” is that sandboxed code cannot call its own functions. How can you correct this problem?

print("\n--- 25.8 ---")

local debug = require "debug"

-- maximum "steps" that can be performed
local steplimit = 1000
local count = 0 -- counter for steps

-- set of authorized functions
local validfunc = {
    [string.upper] = true,
    [string.lower] = true,
}

local function hook (event)
    if event == "call" then
        local info = debug.getinfo(2)
        for i = 1, math.huge do
            local n, v = debug.getlocal(3, i)
            if not n then break end
            if v == info.func then
                found = true
            end
        end
        if found then
            -- print("that's local:", info.name)
        elseif not validfunc[info.func] then
            error("calling bad function: " .. (info.name or "?"))
        end
    end
    count = count + 1
    if count > steplimit then
        error("script uses too much CPU")
    end
end

-- load chunk
local f = assert(loadfile("test25-8.lua", "t", {}))
debug.sethook(hook, "c", 100) -- set hook
validfunc[f] = true

f() -- run chunk

--]]
