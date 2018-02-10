-- Chapter 15. Data Files and Serialization

---[[
-- 15.1: Modify the code in Figure 15.2, "Serializing tables without cycles" so that it indents nested tables. (Hint: add an extra parameter to serialize with the indentation string.)

function serialize (o, indent)
    indent = indent or ""
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
        io.write(string.format("%q", o))
    elseif t == "table" then
        io.write("{\n")
        for k,v in pairs(o) do
            io.write(indent .. "  ", k, " = ")
            serialize(v, indent .. "  ")
            io.write(",\n")
        end
        io.write(indent, "}")
    else
        error("cannot serialize a " .. type(o))
    end
end

print("--- 15.1 ---")
serialize{a=12, b='Lua', key='another "one"', t={a=1, b=2, c=3, t={a=1, b=2}}}

--]]


---[[
-- 15.2: Modify the code of the previous exercise so that it uses the syntax ["key"] = value, as suggested in the section called "Saving tables without cycles".

function serialize (o, indent)
    indent = indent or ""
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
        io.write(string.format("%q", o))
    elseif t == "table" then
        io.write("{\n")
        for k,v in pairs(o) do
            io.write(indent .. "  [")
            serialize(k)
            io.write("] = ")
            serialize(v, indent .. "  ")
            io.write(",\n")
        end
        io.write(indent, "}")
    else
        error("cannot serialize a " .. type(o))
    end
end

print("\n--- 15.2 ---")
serialize{a=12, b='Lua', key='another "one"', t={a=1, b=2, c=3, t={a=1, b=2}}}

--]]


---[[
-- 15.3: Modify the code of the previous exercise so that it uses the syntax ["key"]=value only when necessary (that is, when the key is a string but not a valid identifer).

function serialize (o, indent)
    indent = indent or ""
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
        io.write(string.format("%q", o))
    elseif t == "table" then
        io.write("{\n")
        for k,v in pairs(o) do
            if type(k) == "string" then
                io.write(indent .. "  ", k, " = ")
            else
                io.write(indent .. "  [")
                serialize(k)
                io.write("] = ")
            end
            serialize(v, indent .. "  ")
            io.write(",\n")
        end
        io.write(indent, "}")
    else
        error("cannot serialize a " .. type(o))
    end
end

print("\n--- 15.3 ---")
serialize{a=12, b='Lua', [64]='another "one"', t={a=1, [22]=2, c=3, t={a=1, [true]=2}}}

--]]


---[[
-- 15.4: Modify the code of the previous exercise so that it uses the constructor syntax for lists whenever possible. For instance, it should serialize the table {14, 15, 19} as {14, 15, 19}, not as { [1] = 14, [2] = 15, [3] = 19}. (Hint: start by saving the values of the keys 1, 2, ..., as long as they are not nil. Take care not to save them again when traversing the rest of the table.)

function serialize (o, indent)
    indent = indent or ""
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
        io.write(string.format("%q", o))
    elseif t == "table" then
        io.write("{\n")
        local writed = {}
        for i = 1, #o do
            io.write(indent .. "  ")
            serialize(o[i], indent .. "  ")
            io.write(",\n")
            writed[i] = true
        end

        for k, v in pairs(o) do
            if not writed[k] then
                if type(k) == "string" then
                    io.write(indent .. "  ", k, " = ")
                else
                    io.write(indent .. "  [")
                    serialize(k)
                    io.write("] = ")
                end
                serialize(v, indent .. "  ")
                io.write(",\n")
            end
        end
        io.write(indent, "}")
    else
        error("cannot serialize a " .. type(o))
    end
end

print("\n--- 15.4 ---")
serialize{a=12, b='Lua', [64]='another "one"', t={14, 15, 19, a=1, [22]=2, c=3, t={21, 22, 23}}}

--]]


---[[
-- 15.5: The approach of avoiding constructors when saving tables with cycles is too radical. It is possible to save the table in a more pleasant format using constructors for the simple case, and to use assignments later only to fix sharing and loops. Reimplement the function save (Figure 15.3, "Saving tables with cycles") using this approach. Add ot it all the goodies that you have implemented in the previous exercises (indentation, record syntax, and list syntax).

function basicSerialize (o)
    -- assume 'o' is a number or a string
    return string.format("%q", o)
end

function serialize (name, o, saved, fixed, jumped, indent)
    indent = indent or ""
    local t = type(o)
    if t == "number" or t == "string" or t == "boolean" or t == "nil" then
        io.write(string.format("%q", o))
    elseif t == "table" then
        if saved[o] then
            io.write(saved[o]) -- use its previous name
        else
            io.write("{\n")
            local writed = {}
            for i = 1, #o do
                local fname = string.format("%s[%s]", name, basicSerialize(i))
                if fixed[o[i]] then
                    jumped[fname] = fixed[o[i]]
                else
                    io.write(indent .. "  ")
                    serialize(fname, o[i], saved, fixed, jumped, indent .. "  ")
                    io.write(",\n")
                end
                writed[i] = true
            end

            for k, v in pairs(o) do
                local fname = string.format("%s[%s]", name, basicSerialize(k))
                if not writed[k] then
                    if fixed[v] then
                        jumped[fname] = fixed[v]
                    else
                        if type(k) == "string" then
                            io.write(indent .. "  ", k, " = ")
                        else
                            io.write(indent .. "  [")
                            basicSerialize(k)
                            io.write("] = ")
                        end
                        serialize(fname, v, saved, fixed, jumped, indent .. "  ")
                        io.write(",\n")
                    end
                end
            end
            io.write(indent, "}")
            fixed[o] = name
        end
    else
        error("cannot serialize a " .. type(o))
    end
end

function save (name, value, saved)
    saved = saved or {} -- initial value
    io.write(name, " = ")
    if type(value) == "number" or type(value) == "string" then
        io.write(basicSerialize(value), "\n")
    elseif type(value) == "table" then
        if saved[value] then -- value already saved?
            io.write(saved[value], "\n") -- use its previous name
        else
            local fixed = {}
            fixed[value] = name
            local jumped = {}
            serialize(name, value, saved, fixed, jumped)
            io.write("\n")
            for k, v in pairs(jumped) do
                io.write(string.format("%s = %s\n", k, v))
            end
            for k, v in pairs(fixed) do
                saved[k] = v
            end
        end
    else
        error("cannot save a " .. type(value))
    end
end

print("\n--- 15.5 ---")
o = {1, 2, 3}
a = {{"one", "two"}, 3, o, wtf = o}
a.copy = a
a[1]["test"] = a
b = {k = a[1], sb = o}
local t = {}
save("a", a, t)
save("b", b, t)

--]]