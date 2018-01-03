function repr(data, level)
    if not level then
        level = 1
    end

    local data_type = type(data)

    if data_type == 'table' then
        if level == nil then
            level = 1
        end

        local length = 0
        local has_table = false
        local string_keys = false
        for i, v in pairs(data) do
            if type(v) == 'table' then
                has_table = true
            end
            if type(i) ~= 'number' then
                string_keys = true
            end
            length = length + 1
        end

        io.write('{')

        local iter_func = nil
        if string_keys then
            iter_func = pairs
        else
            iter_func = ipairs
        end

        local h = 1
        for i, v in iter_func(data) do
            if has_table or string_keys then
                io.write('\n  ')
                for j=1, level do
                    if j > 1 then
                        io.write('  ')
                    end
                end
            end
            if string_keys then
                io.write('[')
                repr(i, level + 1)
                io.write('] = ')
            end
            if type(v) == 'table' then
                repr(v, level + 1)
            else
                repr(v, level + 1)
            end
            if h < length then
                io.write(', ')
            end
            h = h + 1
        end
        if has_table or string_keys then
            io.write('\n')
            for j=1, level do
                if j > 1 then
                    io.write('  ')
                end
            end
        end
        io.write('}')

    elseif data_type == 'string' then
        io.write("'")
        for char in data:gmatch('.') do
            local num = string.byte(char)
            if (num >= 0 and num <= 8) or num == 11 or num == 12 or (num >= 14 and num <= 31) or num >= 127 then
                io.write('\\x')
                io.write(string.format('%02X', num))
            elseif num == 92 or num == 39 then
                io.write('\\')
                io.write(char)
            elseif num == 9 then
                io.write('\\t')
            elseif num == 10 then
                io.write('\\n')
            elseif num == 13 then
                io.write('\\r')
            else
                io.write(char)
            end
        end
        io.write("'")

    elseif data_type == 'nil' then
        io.write('nil')

    else
        io.write(data)
    end

    if level == 1 or data_type == 'table' then
        io.write('\n')
    end

    io.flush()
end