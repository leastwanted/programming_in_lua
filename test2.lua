-- Chapter 2. Interlude: The Eight-Queen Puzzle

N = 8 -- board size

countof_placeok = 0

-- check whether position (n,c) is free from attacks
function isplaceok (a, n, c)
    countof_placeok = countof_placeok + 1
    for i = 1, n - 1 do -- for each queen already placed
        if (a[i] == c) or -- same column?
        (a[i] - i == c - n) or -- same diagonal?
        (a[i] + i == c + n) then -- same diagonal?
            return false -- place can be attacked
        end
    end
    return true -- no attacks; place is OK
end

-- print a board
function printsolution (a)
    for i = 1, N do -- for each row
        for j = 1, N do -- and for each column
            -- write "X" or "-" plus a space
            io.write(a[i] == j and "X" or "-", " ")
        end
        io.write("\n")
    end
    io.write("\n")
end

-- add to board 'a' all queens from 'n' to 'N'
function addqueen (a, n)
    if n > N then -- all queens have been placed?
        printsolution(a)
    else -- try to place n-th queen
        for c = 1, N do
            if isplaceok(a, n, c) then
                a[n] = c -- place n-th queen at column 'c'
                addqueen(a, n + 1)
            end
        end
    end
end

-- run the program
addqueen({}, 1)


---[[
-- 2.1: Modify the eight-queen program so that it stops after printing the first solution.

first_printed = false

function addqueen_first (a, n)
    if first_printed then return end
    if n > N then -- all queens have been placed?
        printsolution(a)
        first_printed = true
    else -- try to place n-th queen
        for c = 1, N do
            if isplaceok(a, n, c) then
                a[n] = c -- place n-th queen at column 'c'
                addqueen_first(a, n + 1)
            end
        end
    end
end

print("stop after printing the first:")

addqueen_first({}, 1)

--]]


---[[
-- An alternative implementation for the eight-queen problem would be to generate all possible permutations of 1 to 8 and, for each permutation, to check whether it is valid. Change the program to use this approach. How does the performance of the new program compare with the old one? (Hint: compare the total number of permutations with the number of times that the original program calls the function isplaceok.)

printsolution = function () end

countof_placeok = 0
addqueen({}, 1)
print("Count of normal:", countof_placeok)

function isplaceok (a)
    -- only count the call :]
    countof_placeok = countof_placeok + 1
end

function permgen (a, n)
    n = n or #a -- default for 'n' is size of 'a'
    if n <= 1 then -- nothing to change?
        if isplaceok(a) then
            printsolution(a)
        end
    else
        for i = 1, n do
            -- put i-th element as the last one
            a[n], a[i] = a[i], a[n]
            -- generate all permutations of the other elements
            permgen(a, n - 1)
            -- restore i-th element
            a[n], a[i] = a[i], a[n]
        end
    end
end

countof_placeok = 0
permgen({1, 2, 3, 4, 5, 6, 7, 8}, 8)
print("Count of permutations:", countof_placeok)

--]]
