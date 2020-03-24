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
            table.insert(ingredientsInInventory, {item = itemStack.object, count = count})
        end
    end
    return ingredientsInInventory
end

function groupIngredientsInInventoryByEffect(availableIngredients)
    local effectsWithIngredients = {}
    local playerAlchemyLvl = tes3.mobilePlayer["alchemy"].current
    helpers.log("Got player alchemy: " .. tostring(playerAlchemyLvl), "groupIngredientsInInventoryByEffect")
    local visibleEffects = helpers.getNumVisibleAlchemyEffects(playerAlchemyLvl)
    helpers.log("Got visible num effects: " .. tostring(visibleEffects), "groupIngredientsInInventoryByEffect")
    if visibleEffects == 0 then
        return nil
    end
    for _, obj in pairs(availableIngredients) do
        for i = 1, visibleEffects do
            if tes3.getMagicEffect(obj.item.effects[i]) ~= nil then
                local effect = tes3.getMagicEffect(obj.item.effects[i])
                local target = math.max(obj.item.effectAttributeIds[i], obj.item.effectSkillIds[i])
                local effectName = helpers.getEffectName(effect, target)
                local found = false
                for _,j in pairs(effectsWithIngredients) do
                    if j.effectName == effectName then
                        found = true
                        table.insert(j.effectIngreds, {itemName = obj.item.name, count = obj.count})
                        break
                    end
                end
                if found == false then
                    local newEntry = {
                        effectName = effectName,
                        effectIngreds = {
                            [1] = {
                                itemName = obj.item.name,
                                count = obj.count
                            }
                        }
                    }
                    table.insert(effectsWithIngredients, newEntry)
                end
            end
        end
    end
    table.sort(effectsWithIngredients,
        function(a,b)
            return a.effectName < b.effectName
        end)
    return effectsWithIngredients
end

function onCommand()
    helpers.log("Command key pressed", "onCommand")
    local availableIngredients = getInventoryIngredients()
    local groupedPlayerInventoryData = groupIngredientsInInventoryByEffect(availableIngredients)
    helpers.logDisplayStringFromInventoryData(groupedPlayerInventoryData)
end

event.register("initialized", init)
event.register("keyDown", onCommand, { filter = tes3.scanCode.pipe })