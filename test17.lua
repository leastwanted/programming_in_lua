---[[
-- 17.1: Rewrite the implementation of double-ended queues (Figure 14.2, "A double-ended queue") as a proper module.

local List = require("test17-1")

local aList = List.new()
List.pushFirst(aList, 1)
List.pushFirst(aList, 2)
List.pushFirst(aList, 3)
List.pushLast(aList, 4)
print(List.popLast(aList))
print(List.popLast(aList))
print(List.popLast(aList))
print(List.popLast(aList))
for k, v in pairs(aList) do
    print(k, v)
end

--]]


---[[
-- 17.2: Rewrite the implementation of the geometric-region system (the section called "A Taste of Functional Programming") as a proper module.

local Region = require("test17-2")

local c1 = Region.disk(0, 0, 1)
-- Region.plot(Region.difference(c1, Region.translate(c1, 0.3, 0)), 100, 100)

--]]


---[[
-- 17.3: What happens in the search for a library if the path has some fixed component (that is, a component without a question mark)? Can this behavior be useful?

-- Useless
-- For each template, require substitutes the module name for each question mark and checks whether there is a file with the resulting name; if not, it goes to the next template.
-- Because there is no question mark for require to substitute with the module name, the file name for searching is fixed, there will be two consequences:
-- First, the fixed component pointed to no file, then the component will be skipped.
-- Second, the fixed component pointed to a file, then if the component is used, then the file is be loaded for sure.

--]]


---[[
-- 17.4: Write a searcher that searches for Lua files and C libraries at the same time. For instance, the path used for this searcher could be something like this:

-- ./?.lua;./?.so;/usr/lib/lua5.2/?.so;/usr/share/lua5.2/?.lua

-- (Hint: use package.searchpath to find a proper file and then try to load it, first with loadfile and next with package.loadlib.)

local path = "./?.lua;./?.so;/usr/lib/lua5.2/?.so;/usr/share/lua5.2/?.lua;./?.dll"

local function search (modname, path)
    modname = string.gsub(modname, "%.", "/")
    local msg = {}
    for c in string.gmatch(path, "[^;]+") do
        local fname = string.gsub(c, "?", modname)
        local f = io.open(fname)
        if f then
            f:close()
            return fname
        else
            msg[#msg + 1] = string.format("\n\tno file '%s'", fname);
        end
    end
    return nil, table.concat(msg) -- not found
end

local function searcher(modname, path)
    fname = search(modname, path)
    if fname then
        local luaMod = loadfile(fname)
        if luaMod then
            return luaMod
        end
        local clib = package.loadlib(fname, "luaopen_init")
        if clib then
            return clib
        end
    end
    return nil
end

local lua1 = searcher("test17-4", path)
lua1()
local lua2 = searcher("test17-5", path)
print(lua2)

-- local libTest = searcher("md5.core", path)
-- print(libTest)

-- -- for k,v in pairs(package.preload) do
-- --     print(tostring(k))
-- --     print(tostring(v))
-- -- end

-- local core = require"md5.core"
-- print(core)

--]]
