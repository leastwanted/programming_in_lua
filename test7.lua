--[[ 7.1, 7.2
if arg[1] then
	local f = assert(io.open(arg[1], "r"))
	io.input(f)
	if arg[2] then
		print(string.format("Are u sure write %s (y)?", arg[2]))
		local confirm = io.stdin:read()
		if confirm ~= "y" then
			os.exit()
		end
		io.output(io.open(arg[2], "w"))
	end
end

local lines = {}

for line in io.lines() do
	lines[#lines+1] = line
end

table.sort(lines)

for _, l in ipairs(lines) do
	io.write(l, "\n")
end

--]]

--[[ 7.3

local fname = "md5.lua"

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
--]]

--[[ 7.4, 7.5

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

read_last_line(io.open("7.1.txt", "r"), 1)
--]]

--[[ 7.6
local s_mkdir = "mkdir test"
local s_rmdir = "rd test"
local s_dirdir = "dir test"

-- os.execute(s_mkdir)

-- os.execute(s_rmdir)

-- os.execute(s_dirdir)

-- io.popen(s_rmdir)
--]]

--[==[ 7.7
--[[
The Lua standard library is intended to be both small and portable.
Therefore, it is based on the capabilities of the C-standard library for all but a select few functions.
It has no function to change directories; that's why libraries like LFS exist.
--]]

os.execute("cd test && dir")

-- os.execute("dir")

--]==]
