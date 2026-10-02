--Copyright relating to code extracts taken from FAF (as referenced in below comments)
--******************************************************************************************************
--** Copyright (c) 2022  Willem 'Jip' Wijnia
--**
--** Permission is hereby granted, free of charge, to any person obtaining a copy
--** of this software and associated documentation files (the "Software"), to deal
--** in the Software without restriction, including without limitation the rights
--** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--** copies of the Software, and to permit persons to whom the Software is
--** furnished to do so, subject to the following conditions:
--**
--** The above copyright notice and this permission notice shall be included in all
--** copies or substantial portions of the Software.
--**
--** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--** SOFTWARE.
--******************************************************************************************************

--Copy from FAF, refer to above copyright notice:
local SelectUnits = SelectUnits
local CategoriesTech3EngineersAndSACUs = (categories.ENGINEER * categories.TECH3 + categories.SUBCOMMANDER) - (categories.FIELDENGINEER + categories.COMMAND)
local CategoriesTech2Engineers = categories.ENGINEER * categories.TECH2 - (categories.FIELDENGINEER + categories.COMMAND)
local CategoriesFieldEngineers = categories.FIELDENGINEER - categories.COMMAND
local CategoriesTech1Engineers = categories.ENGINEER * categories.TECH1 - (categories.FIELDENGINEER + categories.COMMAND)
local GetFactions = import('/lua/factions.lua').GetFactions

--- Get the faction category for each faction, including custom factions.
--- Equivalent to {categories.UEF, categories.CYBRAN, categories.AEON, categories.SERAPHIM} for the base game.
function GetFactionCategories()
--Copy from FAF, refer to above copyright notice
    local factionCategories = {}

    for _, faction in GetFactions() do
        table.insert(factionCategories, categories[faction['Category']])
    end

    return factionCategories
end

function GetMajorityFaction(units)
    --Copy from FAF, refer to above copyright notice
    local majorityFactionUnits = {}
    local majorityFactionUnitCount = 0

    for _, factionCategory in GetFactionCategories() do
        local factionUnits = EntityCategoryFilterDown(factionCategory, units)
        local factionUnitCount = table.getn(factionUnits)
        if factionUnitCount > majorityFactionUnitCount then
            majorityFactionUnits = factionUnits
            majorityFactionUnitCount = factionUnitCount
        end
    end

    return majorityFactionUnits
end

function FilterHighestTechEngineers()
    --As a starting point, FAF's SelectHighestEngineerAndAssist hotkey was referred to, refer to above copyright notice
    local selection = GetSelectedUnits()

    if selection then
        local tech3EngineersAndSACUs = EntityCategoryFilterDown(CategoriesTech3EngineersAndSACUs, selection)
        local tech2Engineers = EntityCategoryFilterDown(CategoriesTech2Engineers, selection)
        local fieldEngineers = EntityCategoryFilterDown(CategoriesFieldEngineers, selection)
        local tech1Engineers = EntityCategoryFilterDown(CategoriesTech1Engineers, selection)

        local highestTechEngiesAndSacusOfMajorityFaction
        if not table.empty(tech3EngineersAndSACUs) then
            highestTechEngiesAndSacusOfMajorityFaction = GetMajorityFaction(tech3EngineersAndSACUs)
        elseif not table.empty(tech2Engineers) then
            highestTechEngiesAndSacusOfMajorityFaction = GetMajorityFaction(tech2Engineers)
        elseif not table.empty(fieldEngineers) then
            highestTechEngiesAndSacusOfMajorityFaction = GetMajorityFaction(fieldEngineers)
        elseif not table.empty(tech1Engineers) then
            highestTechEngiesAndSacusOfMajorityFaction = GetMajorityFaction(tech1Engineers)
        end

        if highestTechEngiesAndSacusOfMajorityFaction then
            SelectUnits(highestTechEngiesAndSacusOfMajorityFaction)
        end
    end
end