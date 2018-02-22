-- Chapter 24. Coroutines

---[[
-- 24.1: Rewrite the producer-consumer example in the section called "Who Is the boss?" using a producer-driven design, where the consumer is the coroutine and the producer is the main thread.

function producer( ... )
    while true do
        local x = io.read()
        send(x)
    end
end

function consumer( x )
    while true do
        io.write(x, "\n")
        x = receive()
    end
end

function receive()
    return coroutine.yield()
end

function send( x )
    coroutine.resume(consumer, x)
end

print("--- 24.1 ---")

consumer = coroutine.create(consumer)

-- producer()

--]]


---[[
-- 24.2: Exercise 6.5 asked you to write a function that prints all combinations of the elements in a given array. Use coroutines to transform this function into a generator for combinations, to be used like here:

function printResult (a)
    for i = 1, #a do io.write(a[i], " ") end
    io.write("\n")
end

function copy_list(a)
    local res = {}
    for _, v in ipairs(a) do
        table.insert(res, v)
    end
    return res
end

function combgen(a, m, res)
    res = res or {}
    if #a < m then return end
    if m == 0 then
        coroutine.yield(res)
    else
        local a_ = copy_list(a)
        local res_ = copy_list(res)
        table.insert(res_, table.remove(a_, 1))
        combgen(a_, m-1, res_)
        combgen(a_, m, res)
    end
end

function combinations(a, m)
    local co = coroutine.create(function () combgen(a, m) end)
    return function () -- iterator
        local code, res = coroutine.resume(co)
        return res
    end
end

print("\n--- 24.2 ---")

for c in combinations({"a", "b", "c"}, 2) do
    printResult(c)
end

--]]


---[[
-- 24.3: In Figure 24.5, "Running synchronous code on top of the asynchronous library", both the functions getline and putline create a new closure each time they are called. Use memorization to avoid this waste.

local lib = require "async-lib"

function run (code)
    local co = coroutine.wrap(function ()
        code()
        lib.stop() -- finish event loop when done
    end)
    co() -- start coroutine
    lib.runloop() -- start event loop
end

do
    local mem = {} -- memorization table
    setmetatable(mem, {__mode = "k"})
    function putfactory (o)
        local res = mem[o]
        if not res then
            res = (function () coroutine.resume(o) end)
            mem[o] = res
        end
        return res
    end

    mem = {}
    setmetatable(mem, {__mode = "k"})
    function getfactory (o)
        local res = mem[o]
        if not res then
            res = (function (l) coroutine.resume(o, l) end)
            mem[o] = res
        end
        return res
    end
end

function putline (stream, line)
    local co = coroutine.running() -- calling coroutine
    lib.writeline(stream, line, putfactory(co))
    coroutine.yield()
end

function getline (stream, line)
    local co = coroutine.running() -- calling coroutine
    lib.readline(stream, getfactory(co))
    local line = coroutine.yield()
    return line
end

print("\n--- 24.3 ---")

-- run(function ()
--     local t = {}
--     local inp = io.input()
--     local out = io.output()
--     while true do
--         local line = getline(inp)
--         if not line then break end
--         t[#t + 1] = line
--     end
--     for i = #t, 1, -1 do
--         putline(out, t[i] .. "\n")
--     end
-- end)

--]]


---[[
-- 24.4: Write a line iterator for the coroutine-based library (Figure 24.5, “Running synchronous code on top of the asynchronous library”), so that you can read the file with a for loop.

function getline (stream)
    local callback = (function (l) coroutine.yield(l) end)
    lib.readline(stream, callback)
end

function iter ()
    local inp = io.input()
    local co = coroutine.create(function ()
        lib.runloop()
    end)
    return function () -- iterator
        getline(inp)
        local code, line = coroutine.resume(co)
        if not line then
            lib.stop()
            coroutine.resume(co)  -- need to terminate the coroutine
        end
        -- print(coroutine.status(co))
        return line
    end
end

print("\n--- 24.4 ---")

-- for c in iter() do
--     print(c)
-- end

--]]


---[[
-- 24.5: Can you use the coroutine-based library (Figure 24.5, “Running synchronous code on top of the asynchronous library”) to run multiple threads concurrently? What would you have to change?

-- Maybe we need to use different "cmdQueue"

--]]


---[[
-- 24.6:  Implement a transfer function in Lua. If you think about resume–yield as similar to call–return, a transfer would be like a goto: it suspends the running coroutine and resumes any other coroutine, given as an argument. (Hint: use a kind of dispatch to control your coroutines. Then, a transfer would yield to the dispatch signaling the next coroutine to run, and the dispatch would resume that next coroutine.)

local coes = {}

function dispatch()
    while #coes > 0 do
        for _, co in ipairs(coes) do
            coroutine.resume(co)
        end
    end
end

for i = 1, 5 do
    local co = coroutine.create(function ()
        while true do
            print(string.format("coroutine %d", i))
            coroutine.yield()
        end
    end)
    table.insert(coes, co)
end

print("\n--- 24.6 ---")

-- dispatch()

--]]
