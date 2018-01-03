-- print(utf8.char)

s = [=[<![CDATA[
	Hello world
]]>
]=]

print(s)

-- 4.2


s = '\123\0'

print(s)
print(string.len(s))

function insert(s1, pos, s2)
	return s1:sub(1, pos-1) .. s2 .. s1:sub(pos, -1)
end

print(insert("hello world", 1, "start: "))
print(insert("hello world", 7, "small "))

-- 4.5

function remove(s, pos, len)
	return s:sub(1, pos-1) .. s:sub(pos+len, -1)
end

print(remove("hello world", 7, 4))


--4.7

function ispali(s)
	for i = 1, #s/2 do
		if s:sub(i, i) ~= s:sub(-i, -i) then
			return false
		end
	end
	return true
end

print(ispali("step on no pets"))
print(ispali("banana"))

-- 4.8

function filterstr(s, m)
	return s:gsub(m, "")
end

function ispali2(s)
	s = s:gsub("%s", ""):gsub("%p", "")
	print(s)
	return ispali(s)
end

print(filterstr("test   test test", "%s"))

print(ispali2("step    on,,, no   pets"))