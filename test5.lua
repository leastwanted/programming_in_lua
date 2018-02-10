-- Chapter 5. Tables

-- a = {}
-- a[1] = 1
-- a[2] = 1
-- a[3] = nil
-- a[4] = 1

-- print(#a)

-- for k,v in pairs(a) do
-- 	print(k, v)
-- end

-- b = {}
-- b[1] = 1
-- b[10000] = 1

-- print(#b)

-- c = {1, 2, 3, 4, 5}

-- table.remove(c, 3)

-- print(c[3])

---[[
-- 5.1: What will the following script print? Explain.
-- sunday = 'monday'; monday = 'sunday'
-- t = {sunday = 'monday', [sunday] = monday}
-- print(t.sunday, t[sunday], t[t.sunday])

print("--- 5.1 ---")

sunday = 'monday'; monday = 'sunday'
t = {sunday = 'monday', [sunday] = monday}
print(t.sunday, t[sunday], t[t.sunday])

--]]

---[[
-- 5.2: Assume the following code:
-- a = {}; a.a = a
-- What would be the value of a.a.a.a? Is any a in that sequence somehow different from the others?
-- Now, add the next line to the previous code:
-- a.a.a.a = 3
-- What would be the value of a.a.a.a now?

print("\n--- 5.2 ---")

a = {}
a.a = a
print(a.a.a.a)
a.a.a.a = 3
-- print(a.a.a.a)

--]]


---[[
-- 5.3: Suppose that you want to create a table that maps each escape sequence for strings (the section called "Literal strings") to its meaning. How could you write a constructor for that table?

a = {
	["\\"] = 1,
	["\'"] = 1,
}

--]]


---[[
-- 5.4: We can represent a polynomial anx^n + an-1x^n-1 + ... + a1x^1 + a0 in Lua as list of its coefficients, such as {a0, a1, ... an}. Write a function that takes a polynomial (represented as a table) and a value for x and returns the polynomial value.

a = {0, 1, 1, 1, 1}

function calc_poly(coes, x)
	res = 0
	xx = 1
	for i = 1, #coes do
		res = res + coes[i] * xx
		xx = xx * x
	end
	return res
end

print("\n--- 5.4 ---")
print(calc_poly(a, 2))

--]]


---[[
-- 5.5: Can you write the function from the previous item so that it uses at most n additions and n multiplications (and no exponentiations)?

function calc_poly2(coes, x)
	res = 0
	for i = #coes, 2, -1 do
		res = (res + coes[i]) * x
	end
	res = res + coes[1]
	return res
end

a = {0,1,2,3,4,5}

print("\n--- 5.5 ---")
print(calc_poly2(a, 2))
print(calc_poly(a, 2))
b = calc_poly(a, 1) == calc_poly2(a, 1)
print("equal:", (calc_poly(a, 2) == calc_poly2(a, 2)))

--]]


---[[
-- 5.6: Write a function to test whether a given table is a valid sequence.

function valid_table(t)
	n = 0
	for k, v in pairs(t) do
		n = n+1
	end
	for i = 1, n do
		if t[i] == nil then
			return false
		end
	end
	return true
end

print("\n--- 5.6 ---")
print("issequence:" .. tostring(valid_table({1,3,4})))
a = {}
a[1] = 1
a[2] = 1
a[3] = nil
a[4] = 1
print("issequence:" .. tostring(valid_table(a)))

--]]


---[[
-- 5.7: Write a function that inserts all elements of a given list into a given position of another given list.

a = {1,2,3,4,5}

b = {"a","b","c","d","e"}

-- table.move(a, 1, #a, 3, b)  #only 5.3

function insert_elem(a, b, pos)
	for i = 1, #a do
		table.insert(b, pos - 1 + i, a[i])
	end
end

print("\n--- 5.7 ---")
insert_elem(a, b, 3)
for i = 1, #b do
	print(b[i])
end

--]]


---[[
-- 5.8: The table library offers a function table.concat, which receives a list of strings and returns their concatenation:

-- print(table.concat({"hello", "", "world"}))

-- Write your own version for this function.
-- Compare the performance of your implementation against the built-in version for large lists, with hundres of thousands of entries. (You can use a for loop to create those large lists.)

t = {}
for i = 1,100000 do
	table.insert(t, "abc")
end

print("\n--- 5.8 ---")

function cancat(t)
	res = ""
	for i = 1, #t do
		res = res .. t[i]
	end
	return res
end

x = os.clock()
cancat(t)
print(string.format("time count of my func: %f", os.clock() - x))

x = os.clock()
table.concat(t)
print(string.format("time count of built-in: %f", os.clock() - x))

--]]
