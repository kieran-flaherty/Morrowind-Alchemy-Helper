local Helpers = {}

function Helpers.log(data, funcName)
    funcName = funcName or ""
    local logString = string.format("[alchemy][%s] %s", funcName, data)
    print(logString)
end

return Helpers