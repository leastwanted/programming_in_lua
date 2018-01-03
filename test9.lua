
-- 9.1: Write a function integral that takes a function f and returns an approximation of it integral.

function integral (f, delta)
    delta = delta or 1e-4
    return function (a, b)
        local sum = 0
        for x = a, b, delta do
            sum = sum + f(x) * delta
        end
        return sum
    end
end

fi = integral(function (x) return x end)

print(fi(0, 1))
print(fi(0, 2))

--]]


--[[
-- 9.2: What will be the output of the following chunk:

function F(x)
    return {
        set = function (y) x = y end,
        get = function () return x end
    }
end

o1 = F(10)
o2 = F(20)
print(o1.get(), o2.get())
-- 10 20

o2.set(100)
o1.set(300)
print(o1.get(), o2.get())
-- 300 100

--]]


--[[
-- 9.3: rewrite 5.4

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

function newpoly(coes)
    return function(x)
        local res = 0
        local xx = 1
        for i = 1, #coes do
            res = res + coes[i] * xx
            xx = xx * x
        end
        return res
    end
end

print(calc_poly(a, 2))

f = newpoly(a)

print(f(2))

--]]


--[[
-- 9.4: Using our system for geometric regions, draw a waxing crescent moon as see from the northern Hemisphere

function disk (cx, cy, r)
    return function (x, y)
        return (x - cx)^2 + (y - cy)^2 <= r^2
    end
end

function rect (left, right, bottom, up)
    return function (x, y)
        return left <= x and x <= right and
            bottom <= x and x <= up
    end
end

function complement (r)
    return function (x, y)
        return not r(x, y)
    end
end

function union (r1, r2)
    return function (x, y)
        return r1(x, y) or r2(x, y)
    end
end

function intersection (r1, r2)
    return function (x, y)
        return r1(x, y) and r2(x, y)
    end
end

function difference (r1, r2)
    return function (x, y)
        return r1(x, y) and not r2(x, y)
    end
end

function translate (r, dx, dy)
    return function (x, y)
        return r(x - dx, y - dy)
    end
end

function plot (r, M, N)
    io.write("P1\n", M, " ", N, "\n") -- header
    for i = 1, N do -- for each line
        local y = (N - i*2)/N
        for j = 1, M do -- for each column
            local x = (j*2 - M)/M
            io.write(r(x, y) and "1" or "0")
        end
        io.write("\n")
    end
end

-- io.output(io.open("test9.txt", "w"))
c1 = disk(0, 0, 1)
plot(difference(c1, translate(c1, 0.3, 0)), 100, 100)

-- plot(difference(c1, translate(c1, -0.3, 0)), 100, 100)

--]]


--[[
-- 9.5: In our system for geometric regions, add a function to rotate a given region by a given angle.

function rotate (r, angle, cx, cy)
    local s = math.sin(math.rad(angle))
    local c = math.cos(math.rad(angle))
    cx = cx or 0
    cy = cy or 0
    return function (x, y)
        x = x - cx
        y = y - cy
        local xnew = x * c - y * s
        local ynew = x * s + y * c
        return r(xnew + cx, ynew + cy)
    end
end

plot(rotate(difference(c1, translate(c1, 0.3, 0)), 90), 100, 100)

--]]