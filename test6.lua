-- Chapter 6. Functions

---[[
-- 6.1: Write a function that takes an array and prints all its elements.

function print_array(a)
	for _, v in ipairs(a) do
		print(v)
	end
end

print("--- 6.1 ---")
print_array({"a", nil, nil, "b", "d", 0})

--]]


---[[
-- 6.2: Write a function that takes an arbitrary number of values and returns all of them, except the first one.

function remove_first(a, ...)
	return ...
end

print("\n--- 6.2 ---")
print(remove_first(1, "b", 3))

--]]


---[[
-- 6.3: Write a function that takes an arbitrary number of values and returns all of them, except the last one.

function remove_last(a, ...)
	local n = select("#", ...)
	if n >= 1 then
		return a, remove_last(...)
	end
end

print("\n--- 6.3 ---")
print(remove_last(5, 3, "a", "b"))

--]]


---[[
-- 6.4: Write a function to shuffle a given list. Make sure that all permutations are equally probable.

math.randomseed(os.time())
math.random()

function shuffle(a, start)
	start = start or 1
	local i = math.random(start, #a)
	local c = a[start]
	a[start] = a[i]
	a[i] = c
	if start < #a then
		shuffle(a, start+1)
	end
end

b = {1, 2, 3, 4, 5, 6, 7}
c = shuffle(b)

print("\n--- 6.4 ---")
print_array(b)

--]]


---[[
-- 6.5: Write a function that takes an array and prints all combinations of the elements in the array. (Hint: you can use the recursive formula for combination: C(n,m) = C(n -1, m -1) + C(n - 1, m). To generate all C(n,m) combinations of n elements in groups of size m, you first add the first element to the result and then generate all C(n - 1, m - 1) combinations of the remaining elements in the remaining slots; then you remove the first element from the result and then generate all C(n - 1, m) combinations of the remaining elements in the free slots. When n is smaller than m, there are no combinations. When m is zero, there is only one combination, which uses no elements.)

function copy_list(a)
    local res = {}
    for _, v in ipairs(a) do
        table.insert(res, v)
    end
    return res
end

function combination(a, m, res)
    res = res or {}
    if #a < m then return end
    if m == 0 then return print(table.concat(res, ",")) end
    local a_ = copy_list(a)
    local res_ = copy_list(res)
    table.insert(res_, table.remove(a_, 1))
    combination(a_, m, res)
    combination(a_, m-1, res_)
end

print("\n--- 6.5 ---")
combination({1, 2, 3, 4, 5}, 3)

--]]


---[[
-- 6.6: Sometimes, a language with proper-tail calls is called properly tail recursive, with the argument that this property is relevant only when we have recursive calls. (Without recursive calls, the maximum call depth of a program would be statically fixed.)

-- Show that this argument does not hold in a dynamic language like Lua: write a program that performs an unbounded call chain without recursion. (Hint: see the section called “Compilation”.)

print("\n--- 6.6 ---")

function fib(a, b)
	return fib(b, a+b)
end

function fib2()
	-- print(a)
	b = a + b
	a = b - a
	loadstring("fib2()")()
end

a = 1
b = 1

-- lua 5.3
-- fib(1, 1)

-- lu 5.1
-- fib2(1, 1)
-- loadstring("loadstring("")")()

--[=[
In Lua 5.2, `load(ld)` loads a chunk. And if ld is a function, 
load calls it repeatedly to get the chunk pieces. Each call to
ld must return a string that concatenates with previous results. 
A return of an empty string, nil, or no value signals the end of the chunk.

Since `load` will repeatedly calls a function, we can use it to build
an unbounded call chain with random numbers.
-- ]]

n = math.random(123456789)

function f ()
  n = n - 1;
  if n < 0 then
    return nil
  else
    return 'i = 1;' 
  end
end 

load(f)()
--]=]
