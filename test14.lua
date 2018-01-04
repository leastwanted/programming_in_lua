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


---[[
-- 14.3: Modify the graph structure so that it can keep a label for each arc. The structure should represent each arc by an object, too, with two fields: its label and the node it points to. Instead of an adhacent set, each node keeps an incident set that contains the arcs that originate at that node.
-- Adapt the function readgraph to read two node names plus a label from each line in the input file. (Assume that the label is a number.)

local function name2node (graph, name)
    local node = graph[name]
    if not node then
        -- node does not exist; create a new one
        node = {name = name, adj = {}, arc = {}}
        graph[name] = node
    end
    return node
end

function readgraph (input)
    local graph = {}
    for line in input:lines() do
        -- split line in two names
        local namefrom, nameto = string.match(line, "(%S+)%s+(%S+)")
        -- find corresponding nodes
        local from = name2node(graph, namefrom)
        local to = name2node(graph, nameto)
        -- adds 'to' to the adjacent set of 'from'
        from.adj[to] = true
    end
    return graph
end

function readgraph2 (input)
    local graph = {}
    for line in input:lines() do
        -- split line in two names
        local namefrom, nameto, label = string.match(line, "(%S+)%s+(%S+)%s+(%S+)")
        -- find corresponding nodes
        local from = name2node(graph, namefrom)
        local to = name2node(graph, nameto)
        -- adds 'to' to the incident set of 'from'
        label = tonumber(label)
        from.arc[to] = {to=to, label=label}
    end
    return graph
end

function findpath (curr, to, path, visited)
    path = path or {}
    visited = visited or {}
    if visited[curr] then -- node already visited?
        return nil -- no path here
    end
    visited[curr] = true -- mark node as visited
    path[#path + 1] = curr -- add it to path
    if curr == to then -- final node?
        return path
    end
    -- try all adjacent nodes
    for node in pairs(curr.adj) do
        local p = findpath(node, to, path, visited)
        if p then return p end
    end
    table.remove(path) -- remove node from path
end

function findpath2 (curr, to, path, visited)
    path = path or {}
    visited = visited or {}
    if visited[curr] then -- node already visited?
        return nil -- no path here
    end
    visited[curr] = true -- mark node as visited
    path[#path + 1] = curr -- add it to path
    if curr == to then -- final node?
        return path
    end
    -- try all adjacent nodes
    for _, arc in pairs(curr.arc) do
        local p = findpath2(arc.to, to, path, visited)
        if p then return p end
    end
    table.remove(path) -- remove node from path
end

function printpath (path)
    for i = 1, #path do
        print(path[i].name)
    end
end

g = readgraph(io.open("test14.graph", "rb"))
a = name2node(g, "a")
b = name2node(g, "g")
p = findpath(a, b)
if p then printpath(p) end

g = readgraph2(io.open("test14.graph", "rb"))
a = name2node(g, "a")
b = name2node(g, "g")
p = findpath2(a, b)
if p then printpath(p) end

--]]


---[[[
-- 14.4: Assume the graph representation of the previous exercise, where the label of each arc represents the distance between its end nodes. Write a function to find the shortest path between two given nodes, using Dijkstra's algorithm

function Dijkstra(a, b)
    local queue = { a }
    local visited = { [a] = 0 }

    while #queue > 0 do
        table.sort(queue, function(nodeA, nodeB) return visited[nodeA] < visited[nodeB] end)
        local curr = queue[1]
        table.remove(queue, 1)

        for _, arc in pairs(curr.arc) do
            local node = arc.to
            -- print(node.name)
            if not visited[node] then
                visited[node] = math.huge
                table.insert(queue, node)
            end

            if visited[node] > visited[curr] + arc.label then
                node.prev = curr
                visited[node] = visited[curr] + arc.label
            end
        end
    end

    local path = {}
    if visited[b] then
        local curr = b
        table.insert(path, b)
        while curr.prev do
            curr = curr.prev
            table.insert(path, 1, curr)
        end
    end
    return path
end

g = readgraph2(io.open("test14.graph", "rb"))
a = name2node(g, "a")
b = name2node(g, "g")
p = Dijkstra(a, b)
print("Dijkstra:")
if p then printpath(p) end

--]]