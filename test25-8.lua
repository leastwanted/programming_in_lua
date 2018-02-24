local a = 1
local b = "xx"
b:upper()
-- string.upper("x")
-- print(b)

local helper =  function ( ... )
    b = 3
end

helper()