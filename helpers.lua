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

function Helpers.getEffectName(effect, stat)
    local statName
    if effect.targetsAttributes then
        statName = tes3.findGMST(888 + stat).value
    elseif effect.targetsSkills then
        statName = tes3.findGMST(896 + stat).value
    end

    local effectName = tes3.findGMST(1283 + effect.id).value
    if statName then
        return effectName:match("%S+") .. " " .. statName
    else
        return effectName
    end
end

return Helpers