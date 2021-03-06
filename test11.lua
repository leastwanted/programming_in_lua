-- Chapter 11. Interlude: Most Frequent Words

-- lua test11.lua 10 < book.of

-- 11.1: When we apply the word-frequency program to a text, usually the most frequent words are uninteresting small words like articles and prepositions. Change the program so that it ignores words with less than four letters.

-- 11.2: Repeat the previous exercise but, instead of using length as the criterion for ignoring a word, the program should read from a text file a list of words to be ignored.

-- 11.2 read ignore words from a file
local ignores = {}

local f = io.open("ignores.txt", "r")
for line in f:lines() do
    for word in string.gmatch(line, "%w+") do
        ignores[word] = 1
    end
end

local counter = {}

for line in io.lines() do
    for word in string.gmatch(line, "%w+") do
        -- 11.1: ignore words with less than four letters
        if word:len() >= 4 and not ignores[word] then
            counter[word] = (counter[word] or 0) + 1
        end
    end
end

local words = {} -- list of all words found in the text

for w in pairs(counter) do
    words[#words + 1] = w
end

table.sort(words, function (w1, w2)
    return counter[w1] > counter[w2] or
        counter[w1] == counter[w2] and w1 < w2
end)

-- number of words to print
local n = math.min(tonumber(arg[1]) or math.huge, #words)
for i = 1, n do
    io.write(words[i], "\t", counter[words[i]], "\n")
end
