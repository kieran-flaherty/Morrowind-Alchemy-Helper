local Helpers = {}

function Helpers.log(data, funcName)
    funcName = funcName or ""
    data = data or ""
    local dateString = os.date("%d-%m-%Y %H:%M:%S")
    local logString = string.format("[%s][alchemy][%s] %s", dateString,funcName, data)
    print(logString)
end

function Helpers.hasValue(tab, value)
    for _, val in ipairs(tab) do
        if val == value then return true end
    end
    return false
end

function Helpers.tableString(tab, indentLevel)
    if indentLevel == nil then indentLevel = 0 end
    if type(tab) == 'table' then
        local s = '{\n'
        for k,v in pairs(tab) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            if type(v) == 'table' then
                v = Helpers.tableString(v, indentLevel + 1)
                s = s .. string.rep('\t', indentLevel + 1) .. '['..k..'] = ' .. v .. ',\n'
            else
                s = s .. string.rep('\t', indentLevel + 1 ) .. '['..k..'] = ' .. v .. ',\n'
            end
        end
        return s .. string.rep('\t', indentLevel) ..'}'
    else
        return ""
    end
end

return Helpers