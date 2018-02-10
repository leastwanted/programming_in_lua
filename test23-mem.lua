local count = 0

local mt = {__gc = function () count = count -1 end}
local a = {}

for i = 1, 10000000 do
    count = count + 1
    a[i] = setmetatable({}, mt)
end