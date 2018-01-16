-- Chapter 19. Interlude: Markov Chain Algorithm

--- 19.1 Generalize the Markov-chain algorithm so that it can use any size for the sequence of previous words used in the choice of the next word.

function allwords ()
    local line = io.read() -- current line
    local pos = 1 -- current position in the line
    return function () -- iterator function
        while line do -- repeat while there are lines
            local w, e = string.match(line, "(%w+[,;.:]?)()", pos)
            if w then -- found a word?
                pos = e -- update next position
                return w -- return the word
            else
                line = io.read() -- word not found; try next line
                pos = 1 -- restart from first position
            end
        end
        return nil -- no more lines: end of traversal
    end
end

function prefix (w1, w2)
    return w1 .. " " .. w2
end

function prefix (t)
    -- fix for n
    return table.concat(t, " ")
end

local statetab = {}

function insert (prefix, value)
    local list = statetab[prefix]
    if list == nil then
        statetab[prefix] = {value}
    else
        list[#list + 1] = value
    end
end


local MAXGEN = 200
local NOWORD = "\n"

math.randomseed(os.time())
math.random()
io.input(io.open("test19.txt", "r"))

--[[ the 2 prefix case
-- build table
local w1, w2 = NOWORD, NOWORD
for nextword in allwords() do
    insert(prefix(w1, w2), nextword)
    w1 = w2
    w2 = nextword
end
insert(prefix(w1, w2), NOWORD)

-- generate text
w1 = NOWORD
w2 = NOWORD -- reinitialize
for i = 1, MAXGEN do
    local list = statetab[prefix(w1, w2)]
    -- choose a random item from list
    local r = math.random(#list)
    local nextword = list[r]
    if nextword == NOWORD then return end
    io.write(nextword, " ")
    w1 = w2
    w2 = nextword
end
--]]


PREFIX_COUNT = 2

local prefix_table = {}
for i = 1, PREFIX_COUNT do
    prefix_table[#prefix_table+1] = NOWORD
end

function push(t, w)
    table.insert(t, w)
    table.remove(t, 1)
end

-- build table
for nextword in allwords() do
    insert(prefix(prefix_table), nextword)
    push(prefix_table, nextword)
end
insert(prefix(prefix_table), NOWORD)

-- generate text
local prefix_table = {}
for i = 1, PREFIX_COUNT do
    prefix_table[#prefix_table+1] = NOWORD
end
for i = 1, MAXGEN do
    local list = statetab[prefix(prefix_table)]
    -- choose a random item from list
    local r = math.random(#list)
    local nextword = list[r]
    if nextword == NOWORD then return end
    io.write(nextword, " ")
    push(prefix_table, nextword)
end
