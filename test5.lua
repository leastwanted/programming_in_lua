a = {}
a[1] = 1
a[2] = 1
a[3] = nil
a[4] = 1

print(#a)

for k,v in pairs(a) do
	print(k, v)
end

b = {}
b[1] = 1
b[10000] = 1

print(#b)

c = {1, 2, 3, 4, 5}

table.remove(c, 3)

print(c[3])

-- 5.1

sunday = 'monday'; monday = 'sunday'
t = {sunday = 'monday', [sunday] = monday}
print(t.sunday, t[sunday], t[t.sunday])


--5.2

a = {}
a.a = a

print(a.a.a.a)

a.a.a.a = 3

-- print(a.a.a.a)

--5.3

a = {
	["\\"] = 1,
	["\'"] = 1,
}


--5.4

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

print(calc_poly(a, 2))

--5.5

function calc_poly2(coes, x)
	res = 0
	for i = #coes, 2, -1 do
		-- print(i)
		res = (res + coes[i]) * x
	end
	res = res + coes[1]
	return res
end

a = {0,1,2,3,4,5}

print(calc_poly2(a, 2))
print(calc_poly(a, 2))
b = calc_poly(a, 1) == calc_poly2(a, 1)
print("equal:", (calc_poly(a, 2) == calc_poly2(a, 2)))


--5.6

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

print("issequence:" .. tostring(valid_table({1,3,4})))
a = {}
a[1] = 1
a[2] = 1
a[3] = nil
a[4] = 1
print("issequence:" .. tostring(valid_table(a)))

--5.7

a = {1,2,3,4,5}

b = {"a","b","c","d","e"}

-- table.move(a, 1, #a, 3, b)  #only 5.3

for i = 1, #a do
	table.insert(b, 3 - 1 + i, a[i])
end


for i = 1, #b do
	print(b[i])
end
-- print(b)

-- 5.8

t = {}
for i = 1,100000 do
	table.insert(t, "abc")
end

print(table.concat)

function cancat(t)
	res = ""
	for i = 1, #t do
		res = res .. t[i]
	end
	return res
end
x = os.clock()
cancat(t)
print(string.format("time count: %f", os.clock() - x))
x = os.clock()
table.concat(t)
print(string.format("time count: %f", os.clock() - x))