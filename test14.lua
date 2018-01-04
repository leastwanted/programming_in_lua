-- [[[
-- 14.1: Write a function to add two sparse matrices.

local function print_matrice(a, n)
    for i = 1, #a do
        local t = {}
        for k, v in pairs(a[i]) do
            table.insert(t, (string.format("%d:%s", k, v)))
        end
        print(table.concat(t, ", "))
    end
end

local function add_matrices(a, b)
    local c = {} -- resulting matrix
    for i = 1, #a do
        local resultline = {} -- will be 'c[i]'
        for j, va in pairs(a[i]) do
            local res = (resultline[j] or 0) + va
            resultline[j] = (res ~= 0) and res or nil
        end
        for j, vb in pairs(b[i]) do
            local res = (resultline[j] or 0) + vb
            resultline[j] = (res ~= 0) and res or nil
        end
        c[i] = resultline
    end
    return c
end

local a = {
    {1, 0, 0},
    {0, 1, 0},
    {0, 0, 1}
}

local b = {
    {-1, 1, 2},
    {0, 100, 0},
    {6, 3, -1}
}

local c = add_matrices(a, b)
print_matrice(c, 3)

--]]]


---[[
-- 14.2 Modify the queue implementation in Figure 14.2, "A double-ended queue" so that both indices return to zero when the queue is empty.

function listNew ()
    return {first = 0, last = 0}
end

function reset(list)
    if list.first == list.last then
        list.first = 0
        list.last = 0
    end
end

function pushFirst (list, value)
    list[list.first] = value
    list.first = list.first - 1
end

function pushLast (list, value)
    local last = list.last + 1
    list[last] = value
    list.last = last
end

function popFirst (list)
    local first = list.first
    if first >= list.last then error("list is empty") end
    local value = list[first+1]
    list[first+1] = nil -- to allow garbage collection
    list.first = first + 1
    reset(list)
    return value
end

function popLast (list)
    local last = list.last
    if list.first >= last then error("list is empty") end
    local value = list[last]
    list[last] = nil -- to allow garbage collection
    list.last = last - 1
    reset(list)
    return value
end

local aList = listNew()
pushFirst(aList, 1)
pushFirst(aList, 2)
pushFirst(aList, 3)
pushLast(aList, 4)
print(popLast(aList))
print(popLast(aList))
print(popLast(aList))
print(popLast(aList))
for k, v in pairs(aList) do
    print(k, v)
end

--]]