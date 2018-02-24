a = 1
for i = 1, 10 do
    math.random(a)
end

function helper(x)
    x = x + 1
end

for i = 1, 5 do
    helper(i)
end
