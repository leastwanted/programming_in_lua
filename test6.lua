-- 6.1

function print_array(a)
	for _, v in ipairs(a) do
		print(v)
	end
end

print_array({"a", nil, nil, "b", "d", 0})


-- 6.2

function remove_first(a, ...)
	return ...
end

print(remove_first(1, "b", 3))


-- 6.3

-- print(select)

function remove_last(a, ...)
	local n = select("#", ...)
	if n >= 1 then
		return a, remove_last(...)
	end
end

print(remove_last(5, 3, "a", "b"))


--6.4
math.randomseed(os.time())
print(math.random())

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

print_array(b)


-- 6.5


-- 6.6

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