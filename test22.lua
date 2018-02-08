-- Chapter22. The Environment

---[[
-- 22.1: The function getfield that we defined in the beginning of this chapter is too forgiving, as it accepts "fields" like math?sin or string!!!gsub. Rewrite it so that it accepts only single dots as name separators.

function getfield(f)
    local v = _G
    for w in string.gmatch(f, "(.-)%.") do
        if string.match(w, "^[%a_][%w_]*$") then
            v = v[w]
        else
            error("not ok")
        end
    end
    local w = string.match(f, "[%a_][%w_]*$")
    if w then
        v = v[w]
    else
        error("not ok")
    end
    return v
end

a = {b = {c = 1}}
d = getfield("a.b.c")

--]]


---[[
-- 22.2: Explain in detail what happens in the following program and what it will print.

-- local foo
-- do
--     local _ENV = _ENV  -- _ENV is the table of _G
--     function foo( ... )
--         print(X)  -- compiled as _ENV.X or _G.X
--     end
-- end
-- X = 13  -- _G.X = 13
-- _ENV = nil
-- foo()  -- foo is local var
-- X = 0  -- X is compiled as _ENV.X and _ENV is nil

--]]


---[[
-- 22.3: Explain in detail what happens in the following program and what it will print.

local print = print
function foo(_ENV, a)
    print(a + b)  -- compiled as print(a + _ENV.b)
end

foo({b = 14}, 12)
foo({b = 10}, 1)

--]]
