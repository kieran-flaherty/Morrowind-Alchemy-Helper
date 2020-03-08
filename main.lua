local ingredients = require('alchemy.ingredients')
local helpers = require('alchemy.helpers')

function init(e)
    helpers.log("Initialising..", "init")
    for _, ing in ipairs(ingredients) do
        helpers.log(string.format("Got ingredient: %s", ing), "init")
    end
end

function getInventoryIngredients()
    helpers.log("Getting inventory ingredients...", "getInventoryIngredients")
    local ingredientsInInventory = {}
    for itemStack in tes3.iterate(tes3.player.object.inventory.iterator) do
        local count = itemStack.count
        if helpers.hasValue(ingredients, tostring(itemStack.object)) then
            helpers.log(string.format("Found ingredient: %s, count: %d", itemStack.object, count),
                "getInventoryIngredients")
            table.insert(ingredientsInInventory, {item = tostring(itemStack.object), count = count})
        end
    end
    return ingredientsInInventory
end

function onCommand()
    helpers.log(nil, "onCommand")
    local availableIngredients = getInventoryIngredients()
    helpers.log(string.format("Avaliable ingredients: %s", helpers.tableString(availableIngredients)), "onCommand")
end

event.register("initialized", init)
event.register("keyDown", onCommand, { filter = tes3.scanCode.pipe })