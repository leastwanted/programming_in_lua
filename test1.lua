-- Chapter 1. Getting Started

---[[
-- 1.1: Run the factorial example. What happens to your program if you enter a negative number? Modify the example to avoid this problem.

function fact (n)
    if n <= 0 then
        return 1
    else
        return n * fact(n - 1)
    end
end
-- print("enter a number:")
-- a = io.read("*n") -- reads a number
-- print(fact(a))

--]]


---[[
-- 1.2: Run the twice example, both by loading the file with the -l option and with dofile. Which way do you prefer

dofile("lib1.lua")
n = norm(3.4, 1.0)
print(twice(n))

-- lua -llib1 -e "print(twice(2))"

--]]

---[[
-- 1.3: Can you name other languages that use "--" for comments?

-- Euphoria, Haskell, SQL, Ada, AppleScript, Eiffel, Lua, VHDL, SGML
-- from https://en.wikipedia.org/wiki/Comparison_of_programming_languages_(syntax)#Comments

--]]


---[[
-- 1.4: Which of the following strings are valid identifiers?

___ = 1

_end = 1

End = 1

-- end = 1

-- until? = 1

-- nil = 1

NULL = 1

-- one-step = 1

--]]


---[[
-- 1.5: What is the value of the expression type(nil) == nil? (You can use Lua to check your answer.) Can you explain this result?

res = type(nil) == nil
print(res)
print(type(nil))

--]]


---[[
-- 1.6: How can you check whether a value is a Boolean without using the function type?

a = 123
res = (a == true or a == false)
print(res)

--]]


---[[
-- 1.7: Consider the following expression:
-- (x and y and (not z)) or ((not y) and x)
-- Are the parentheses necessary? Would you recommend thier use in that expression?

-- necessary

-- Yes, better for people to read the code.

--]]


---[[
-- 1.8: Write a simple script that prints its own name without knowing it in advance.

print(arg[0])

--]]
