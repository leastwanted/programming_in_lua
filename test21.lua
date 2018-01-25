-- Chapter 21. Object-Oriented Programming

---[[
-- 21.1: Implement a class Stack, with methods push, pop, top and isempty.

Stack = {}

function Stack:new()
    local o = {value = {}}
    self.__index = self
    setmetatable(o, self)
    return o
end

function Stack:push(v)
    table.insert(self.value, v)
end

function Stack:pop()
    return table.remove(self.value)
end

function Stack:top()
    return self.value[#self.value]
end

function Stack:isempty()
    return #self.value == 0
end

print("=== 21.1 ===")
local aStack = Stack:new()
aStack:push(1)
aStack:push(2)
aStack:push(3)
print(aStack:pop())
print(aStack:top())
print(aStack:isempty())
print(aStack:pop())
print(aStack:pop())
print(aStack:pop())
print(aStack:isempty())

--]]


---[[
-- 21.2: Implement a class StackQueue as a subclass of Stack. Besides the inherited methods, add to this class a method insertbottom, which inserts an element at the bottom of the stack. (This method allows us to use objects of this class as queues.)

StackQueue = Stack:new()

function StackQueue:insertbottom(v)
    table.insert(self.value, 1, v)
end

local aStack = StackQueue:new()
print("\n=== 21.2 ===")
aStack:push(1)
aStack:push(2)
aStack:push(3)
aStack:insertbottom(4)
print(aStack:pop())
print(aStack:top())
print(aStack:isempty())
print(aStack:pop())
print(aStack:pop())
print(aStack:pop())
print(aStack:isempty())

--]]


---[[
-- 21.3: Reimplement your Stack class using a dual representation.
local value = {}

DualStack = {}

function DualStack:new()
    local o = {}
    self.__index = self
    setmetatable(o, self)
    value[o] = {}
    return o
end

function DualStack:push(v)
    table.insert(value[self], v)
end

function DualStack:pop()
    return table.remove(value[self])
end

function DualStack:top()
    return value[self][#value[self]]
end

function DualStack:isempty()
    return #value[self] == 0
end

print("\n=== 21.3 ===")
local aStack = DualStack:new()
aStack:push(1)
aStack:push(2)
aStack:push(3)
print(aStack:pop())
print(aStack:top())
print(aStack:isempty())
print(aStack:pop())
print(aStack:pop())
print(aStack:pop())
print(aStack:isempty())

--]]


---[[
-- 21.4: A variation of the dual representation is to implement objects using proxies (the section called “Tracking table accesses”). Each object is represented by an empty proxy table. An internal table maps proxies to tables that carry the object state. This internal table is not accessible from the outside, but methods use it to translate their self parameters to the real tables where they operate. Implement the Account example using this approach and discuss its pros and cons.

Account = {balance = 0}

function Account:new (o)
    local proxy = {}
    o = o or {}
    o.__index = {
        deposit = function (_, v)
            o.balance = o.balance + v
        end,
        withdraw = function (_, v)
            if v > o.balance then error"insufficient funds" end
            o.balance = o.balance - v
        end,
        balance = function ()
            return o.balance
        end
    }
    self.__index = self
    setmetatable(o, self)
    setmetatable(proxy, o)
    return proxy
end

print("\n=== 21.4 ===")
local a = Account:new({balance = 0})
local b = Account:new({balance = 999.0})
a:deposit(100.00)
print(a.balance())
a:withdraw(50.0)
print(a.balance())
print(b.balance())
print(a.balance)
-- b:withdraw(1000.0)

--]]
