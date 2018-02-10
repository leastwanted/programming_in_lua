-- Chapter 8. Filling some Gaps

--[[
-- 8.1: Most languages with a C-like syntax do not offer an elseif construct. Why does Lua need this construct more than those languages? it avoids the need for multiple ends.

To avoid [end]

To write nested ifs we can use elseif. It is similar to an else followed by an if, but it avoids the need for multiple ends

--]]


--[[
-- 8.2: Describe four different ways to write an unconditional loop in Lua. Which one do you prefer?

while true do
	print("Loop")
end

repeat
	print("Loop")
until true

for i = 1, math.huge do
	print("Loop")
end

for k, v in pairs(t) do
	print("Loop")
end

-- got not available in 5.1
::Loop:: 
print("Loop")
goto Loop

--]]


--[[
-- 8.3: Many people argue that repeat--unitl is seldom used, and therefore it should not be present in a minimalistic language like Lua. What do you think?

cant agree more before u meet the problem

--]]


---[[
-- 8.4: As we saw in the section called “Proper Tail Calls”, a tail call is a goto in disguise. Using this idea, reimplement the simple maze game from the section called “break, return, and goto” using tail calls. Each block should become a new function, and each goto becomes a tail call.

function room1( ... )
	local move = io.read()
	if move == "south" then
		return room3()
	elseif move == "east" then
		return room2()
	else
		print("invalid move")
		return room1()
	end
end

function room2( ... )
	local move = io.read()
	if move == "south" then
		return room4()
	elseif move == "west" then
		return room1()
	else
		print("invalid move")
		return room2()
	end
end

function room3( ... )
	local move = io.read()
	if move == "north" then
		return room1()
	elseif move == "east" then
		return room4()
	else
		print("invalid move")
		return room3()
	end
end

function room4( ... )
	print("Congratulations, you won！")
end

--]]


--[[
-- 8.5: Can you explain why Lua has the restriction that a goto cannot jump out of a function? (Hint: how would you implement that feature?)

You cannot easily restore the environment of a function, the stack, the local variables; then this is not feasible for running the block in another function.

--]]


--[[
-- 8.6: Assuming that a goto could jump out of a function, explain what the program in Figure 8.3, "A strange (and invalid) use of a goto" would do.

function getlabel ()
	return function () goto L1 end
::L1::
	return 0
end

function f (n)
	if n == 0 then return getlabel()
	else
		local res = f(n - 1)
		print(n)
		return res
	end
end

x = f(10)
x()

-- (Try to reason about the label using the same scoping rules for local variables.)

--]]
