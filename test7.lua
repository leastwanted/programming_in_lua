-- Chapter 7. The External World

---[[
-- 7.1: Write a program that reads a text file and rewrites it with its lines sorted in alphabetical order. When called with no arguments, it should read from standard input and write to standard output. When called with one file-name argument, it should read from that file and write to standard output. When called with two file-name arguments, it should read from the first file and write to the second.

-- 7.2: Change the previous program so that it asks for confirmation if the user gives the name of an existing file for its output.

if arg[1] then
	local f = assert(io.open(arg[1], "r"))
	io.input(f)
	if arg[2] then
		-- 7.2
		print(string.format("Are u sure write %s (y)?", arg[2]))
		local confirm = io.stdin:read()
		if confirm ~= "y" then
			os.exit()
		end
		io.output(io.open(arg[2], "w"))
	end
else
	io.input("test7-1.txt")
end

print('--- 7.1 & 7.2 ---')

local lines = {}

for line in io.lines() do
	lines[#lines+1] = line
end

table.sort(lines)

for _, l in ipairs(lines) do
	io.write(l, "\n")
end

-- 7.1 & 7.2: lua test7.lua test7-1.txt out7-1.txt

--]]


---[[
-- 7.3: Compare the performance of Lua programs that copy the standard input stream to the standard output stream in the following ways:
-- • byte by byte;
-- • line by line;
-- • in chunks of 8 kB;
-- • the whole file at once.
-- For the last option, how large can the input file be?

local fname = "test7-3.txt"

print('\n--- 7.3 ---')
io.output(io.open("test7-3.out", "w"))

local f = io.open(fname, "r")
io.input(f)
local t = os.clock()
while true do
	local byte = io.read(1)
	if byte then 
		io.write(byte)
	else
		break
	end
end
print(string.format("time spent: %f", os.clock() - t))
f:close()

local f = io.open(fname, "r")
io.input(f)
local t = os.clock()
for line in io.lines() do
	io.write(line, "\n")
end
print(string.format("time spent: %f", os.clock() - t))
f:close()

local f = io.open(fname, "r")
io.input(f)
local t = os.clock()
while true do
	local block = io.read(2^13)
	if block then 
		io.write(block)
	else
		break
	end
end
print(string.format("time spent: %f", os.clock() - t))
f:close()

local f = io.open(fname, "r")
io.input(f)
local t = os.clock()
local fall = io.read('*all')
io.write(fall)
print(string.format("time spent: %f", os.clock() - t))
f:close()

io.output()
--]]


---[[
-- 7.4: Write a program that prints the last line of a text file. Try to avoid reading the entire file when the file is large and seekable

-- 7.5: Generalize the previous program so that it prints the last n lines of a text file. Again, try to avoid reading the entire file when the file is large and seekable

function read_last_line(file, n)
	n = n or 1
	local size = file:seek("end")
	local s = nil
	local count = 0
	for i = size, 0, -1 do
		file:seek("set", i)
		s = file:read(1)
		if s == "\n" then
			count = count + 1
			if count == n * 2 then  -- \r\n wtf!
				print(file:read("*a"))
				return
			end
		end
	end
	file:seek("set", 0)
	print(file:read("*a"))
end

print('\n--- 7.4 & 7.5 ---')
read_last_line(io.open("test7-1.txt", "r"), 1)

--]]


---[[
-- 7.6: Using os.execute and io.popen, write functions to create a directory, to remove a directory, and to collect the entries in a directory.

local s_mkdir = "mkdir test"
local s_rmdir = "rd test"
local s_dirdir = "dir test"

-- os.execute(s_mkdir)

-- os.execute(s_rmdir)

-- os.execute(s_dirdir)

-- io.popen(s_rmdir)

--]]


--[==[
-- 7.7: Can you use os.execute to change the current directory of your Lua script? Why?

--[[
The Lua standard library is intended to be both small and portable.
Therefore, it is based on the capabilities of the C-standard library for all but a select few functions.
It has no function to change directories; that's why libraries like LFS exist.
--]]

os.execute("cd test && dir")

-- os.execute("dir")

--]==]
