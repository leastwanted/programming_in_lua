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

consumer = coroutine.create(consumer)

-- producer()

--]]


---[[
-- 24.2: Exercise 6.5 asked you to write a function that prints all combinations of the elements in a given array. Use coroutines to transform this function into a generator for combinations, to be used like here:

function printResult (a)
    for i = 1, #a do io.write(a[i], " ") end
    io.write("\n")
end

function permgen (a, n)
    n = n or #a -- default for 'n' is size of 'a'
    if n <= 1 then -- nothing to change?
        coroutine.yield(a)
    else
        for i = 1, n do
            -- put i-th element as the last one
            a[n], a[i] = a[i], a[n]
            -- generate all permutations of the other elements
            permgen(a, n - 1)
            -- restore i-th element
            a[n], a[i] = a[i], a[n]
        end
    end
end

function permutations (a)
    local co = coroutine.create(function () permgen(a) end)
    return function () -- iterator
        local code, res = coroutine.resume(co)
        return res
    end
end

for c in permutations({"a", "b", "c"}, 2) do
    printResult(c)
end

--]]


---[[
-- 24.3: In Figure 24.5, "Running synchronous code on top of the asynchronous library", both the functions getline and putline create a new closure each time they are called. Use memorization to avoid this waste.

--]]
