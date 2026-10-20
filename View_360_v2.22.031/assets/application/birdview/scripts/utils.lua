FunctionNames = {}

function table.Clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function LinerInterpolate(valueA, valueB, percent)
    return valueA + (valueB - valueA) * percent
end

function RoundInterpolate(valueA, valueB, percent)
    return valueA + (valueB - valueA) * math.sin(math.pi / 2 * percent)
end

function LinerPercent(valueA, valueB, curValue)
    if valueB == valueA then
        do
            return 1
        end
    else
        return (curValue - valueA) / (valueB - valueA)
    end
end

function SPercent(originPercent, times)
    times = times or 1
    local result = originPercent
    -- for i = 1, times do
    -- result = math.sin((result - 0.5)* math.pi) / 2.0 + 0.5
    -- end
    result = -math.sin(2 * math.pi * originPercent) / 2 / math.pi + originPercent
    return result
end

function RoundPercent(valueA, valueB, curValue)
    if valueB == valueA then
        do
            return 1
        end
    else
        local rate = (curValue - valueA) / (valueB - valueA)
        rate = (rate - 0.5) * math.pi
        rate = math.sin(rate) / 2.0 + 0.5
        -- rate = rate ^ 0.5
        return rate
    end
end

function sortKeyCompare(a, b)
    if type(a) == "number" then
        a = tostring(a)
    end
    if type(b) == "number" then
        b = tostring(b)
    end
    return (a < b)
end

function table.Serialize(object, name, level)
    if object == nil then
        return
    end
    local lineBlank = ""
    local iLevel = 0
    while iLevel < level do
        lineBlank = lineBlank .. "	"
        iLevel = iLevel + 1
    end
    local subLineBlank = lineBlank .. "	"
    local key_table = {}
    for key, vv in pairs(object) do
        if type(key) ~= "function" then
            table.insert(key_table, key)
        end
    end
    table.sort(key_table, sortKeyCompare)
    local continueNumberKey = true
    local lastKey = 0
    local allNumber = true
    local tableSize = 0
    for kk, key in pairs(key_table) do
        tableSize = tableSize + 1
        if tonumber(key) then
            if continueNumberKey then
                if key - lastKey ~= 1 then
                    continueNumberKey = false
                    break
                else
                    if type(object[key]) ~= "number" then
                        allNumber = false
                    end
                    lastKey = key
                end
            end
        else
            allNumber = false
            continueNumberKey = false
        end
    end
    if tableSize == 0 then
        allNumber = false
        continueNumberKey = false
    end
    if name ~= "" then
        io.write(lineBlank, name)
    end
    if not allNumber then
        if name ~= "" then
            io.write("\n")
        end
        io.write(lineBlank, "{\n")
    else
        if name == "" then
            io.write(lineBlank)
        end
        io.write("{")
    end
    for kk, k in pairs(key_table) do
        local v = object[k]
        local keyStr = ""
        if continueNumberKey then
        elseif tonumber(k) then
            keyStr = "[" .. k .. "] = "
        else
            local firstChar = string.sub(string.lower(k), 1, 1)
            if firstChar < "a" or firstChar > "z" then
                keyStr = "[\"" .. k .. "\"] = "
            else
                keyStr = k .. " = "
            end
        end
        if type(v) == "number" then
            if allNumber then
                io.write(" ", v)
            else
                io.write(subLineBlank, keyStr, v)
            end
        elseif type(v) == "string" then
            io.write(subLineBlank, keyStr, string.format("%q", v))
        elseif type(v) == "function" and FunctionNames[v] then
            io.write(subLineBlank, keyStr, FunctionNames[v])
        elseif type(v) == "boolean" then
            local boolStr = "true"
            if not v then
                boolStr = "false"
            end
            io.write(subLineBlank, keyStr, boolStr)
        elseif type(v) == "table" then
            table.Serialize(v, keyStr, level + 1)
        end
        io.write(",")
        if not allNumber then
            io.write("\n")
        end
    end
    if allNumber then
        io.write("}")
    else
        io.write(lineBlank, "}")
    end
    if level == 0 then
        io.write("\n\n")
    end
end


