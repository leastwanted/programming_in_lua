---[[
-- 18.1: Write an iterator fromto such that the next loop becomes equivalent to a numeric for:

-- for i in fromto(n, m) do
--     -- body
-- end

function fromto(n, m)
    local i = n - 1
    return function ()
        i = i + 1
        if i <= m then
            return i
        end
        return nil
    end
end

function iter(m, i)
    i = i + 1
    if i <= m then
        return i
    end
    return nil
end

function fromto(n, m)
    -- stateless
    return iter, m, n-1
end

for i in fromto(3, 8) do
    print(i)
end

--]]


---[[
-- 18.2: Add a step parameter to the iterator from the previous exercise. Can you still implement it as a stateless iterator?

function iter(t, i)
    if not i then
        return t.n
    end
    i = i + t.step
    if (t.step > 0 and i <= t.m)
        or (t.step < 0 and i >= t.m) then
        return i
    end
    return nil
end

function fromto(n, m, step)
    -- stateless
    assert(step ~= 0, "Step cannot be zero")
    assert((step > 0 and m >= n) or (step < 0 and m <= n), "Error with parameter")
    step = step or 1
    return iter, {n=n, m=m, step=step}, nil
end

for i in fromto(3, 8, 2) do
    print(i)
end

for i in fromto(1, -5, -2) do
    print(i)
end

--]]


---[[
-- 18.3: Write an iterator uniquewords that returns all words from a given file without repetitions. (Hint: start with the allwords code in Figure 18.1, "Iterator to traverse all words from the standard input"; use a table to keep all words already reported.)

function allwords ()
    local line = io.read() -- current line
    local pos = 1 -- current position in the line
    local wordsReported = {}
    return function () -- iterator function
        while line do -- repeat while there are lines
            local w, e = string.match(line, "(%w+)()", pos)
            if w and not wordsReported[w] then -- found a word?
                pos = e -- next position is after this word
                wordsReported[w] = 1
                return w -- return the word
            else
                line = io.read() -- word not found; try next line
                pos = 1 -- restart from first position
            end
        end
        return nil -- no more lines: end of traversal
    end
end

io.input(io.open("test18.lua", "r"))
for w in allwords() do
    print(w)
end

--]]


---[[
-- 18.4: Write an iterator that returns all non-empty substrings of a given string.

function allsubstring(s)
    local start = 1
    local pos = 0
    return function ()
        pos = pos + 1
        if pos > #s then
            start = start + 1
            pos = start
        end
        if start > #s then
            return nil
        end
        return s:sub(start, pos)
    end
end

for w in allsubstring("abc") do
    print(w)
end

--]]


---[[
-- 18.5: Write a true iterator that traverses all subsets of a given set. (Instead of creating a new table for each subset, it can use the same table for all its results, only changing its contents between iterations.)

function allsubsets(s, f)
    local t = {}
    local n = #s
    for i = 0, (1 << n) - 1 do
        t = {}
        for j = 1, n do
            if ((1 << (j-1)) & i) ~= 0 then
                t[#t + 1] = s[j]
            end
        end
        f(t)
    end
end

function print_subset(t)
    print("{" .. table.concat(t, ", ") .. "}")
end

allsubsets({"a", "b", "c"}, print_subset)

--]]
