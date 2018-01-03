---[[
-- 12.1: Write a function that returns the date-time exactly on month after a given date-time. (Assume the numeric coding of date-time)

local function one_month_passed(t)
    local t = os.date("*t", t)
    t.month = t.month + 1
    return os.time(t)
end

print(os.date("%Y/%m/%d", one_month_passed(os.time())))

--]]


---[[
-- 12.2: Write a function that returns the day of the week (coded as a integer, one is Sunday) of a given date.

local function day_of_week(t)
    local t = os.date("*t", t)
    return t.wday
end

print(string.format("Today is weekday %d", day_of_week(os.time())))

--]]


---[[
-- 12.3: Write a function that takes a date-time(coded as a number) and returns the number of seconds passed since the beginning of its respective day.

local function seconds_passed(t)
    local T = os.date("*t", t)
    local start = os.time({
        year = T.year,
        month = T.month,
        day = T.day,
        hour = 0,
        })
    print(T.hour)
    return os.difftime(t, start)
end

print(string.format("Seconds passed: %d", seconds_passed(os.time())))

--]]


---[[
-- 12.4: Write a function that takes a year and returns the day of its first Friday.

local function first_friday(year)
    local t = os.time({
        year = year,
        month = 1,
        day = 1,
    })
    t = os.date("*t", t)
    t.day = t.day + (6 - t.wday) % 7
    return os.date("*t", os.time(t))
end

local t = first_friday(2018)
print(string.format("First friday of %d is %d-%d : %d", t.year, t.month, t.day, t.wday))

--]]


---[[
-- 12.5: Write a function that computes the number of complete days between two given dates.

local function complete_days(t1, t2)
    t1 = os.time(t1)
    t2 = os.time(t2)
    return math.floor(os.difftime(t2, t1) / (24 * 3600))
end

print("Days between:", complete_days({year=2014, month=12, day=16}, {year=2015, month=1, day=1}))

--]]


---[[
-- 12.6: Write a function that computes the number of complete months between two given dates.

local function complete_months(t1, t2)
    t1 = os.date("*t", os.time(t1))
    t2 = os.date("*t", os.time(t2))
    return (t2.year - t1.year) * 12 + t2.month - t1.month
end

print("Months between:", complete_months({year=2013, month=12, day=16}, {year=2015, month=1, day=1}))

--]]


---[[
-- 12.7: Does adding one month and then one day to a given date give the same results as adding one day and the one month?

local function add_one_month(t)
    t = os.date("*t", t)
    t.month = t.month + 1
    return os.time(t)
end

local function add_one_day(t)
    t = os.date("*t", t)
    t.day = t.day + 1
    return os.time(t)
end

local t = os.time({year=2018, month=1, day=31})
print("Month then day:" .. os.date("%Y/%m/%d", add_one_day(add_one_month(t))))

print("Day then month:" .. os.date("%Y/%m/%d", add_one_month(add_one_day(t))))

--]]


---[[
-- 12.8: Write a function that produces the system's time zone.

local function get_timezone()
    local now = os.time()
    return os.difftime(now, os.time(os.date("!*t", now)))
end
print("Time zone:", get_timezone())

--]]