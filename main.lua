local ingredients = require('alchemy.ingredients')
local helpers = require('alchemy.helpers')

function init(e)
    helpers.log("Initialising..", "init")
    for _, ing in ipairs(ingredients) do
        helpers.log(string.format("Got ingredient: %s", ing), "init")
    end
end

event.register("initialized", init)