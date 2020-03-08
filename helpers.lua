local Helpers = {}

function Helpers.log(data, funcName)
    funcName = funcName or ""
    data = data or ""
    local logString = string.format("[alchemy][%s] %s", funcName, data)
    print(logString)
end

function Helpers.hasValue(tab, value)
    for _, val in ipairs(tab) do
        if val == value then return true end
    end
    return false
end

-- TODO: Improve this with indentation
function Helpers.tableString(tab)
    if type(tab) == 'table' then
        local s = '{\n'
        for k,v in pairs(tab) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            if type(v) == 'table' then v = Helpers.tableString(v) end
            s = s .. '['..k..'] = ' .. v .. ','
        end
        return s .. '\n} '
    else
        return ""
    end
end

return Helpers