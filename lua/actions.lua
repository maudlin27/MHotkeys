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

--Non-FAF:
local SmartSelection = import("/lua/keymap/smartselection.lua")

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
    local tcFactionCategories = {}

    for _, faction in GetFactions() do
        table.insert(tcFactionCategories, categories[faction['Category']])
    end

    return tcFactionCategories
end

function GetMajorityFaction(toUnits)
    --Copy from FAF, refer to above copyright notice
    local toMajorityFactionUnits = {}
    local iMajorityFactionUnitCount = 0

    for _, cFactionCategory in GetFactionCategories() do
        local toFactionUnits = EntityCategoryFilterDown(cFactionCategory, toUnits)
        local iFactionUnitCount = table.getn(toFactionUnits)
        if iFactionUnitCount > iMajorityFactionUnitCount then
            toMajorityFactionUnits = toUnits
            iMajorityFactionUnitCount = iFactionUnitCount
        end
    end

    return toMajorityFactionUnits
end

function FilterHighestTechEngineers()
    --As a starting point, FAF's SelectHighestEngineerAndAssist hotkey was referred to, refer to above copyright notice
    local toSelection = GetSelectedUnits()

    if toSelection then
        local toT3EngineersAndSACUs = EntityCategoryFilterDown(CategoriesTech3EngineersAndSACUs, toSelection)
        local toT2Engineers = EntityCategoryFilterDown(CategoriesTech2Engineers, toSelection)
        local toSparkies = EntityCategoryFilterDown(CategoriesFieldEngineers, toSelection)
        local toT1Engineers = EntityCategoryFilterDown(CategoriesTech1Engineers, toSelection)

        local toHighestTechEngiesOfMajorityFaction
        if not table.empty(toT3EngineersAndSACUs) then
            toHighestTechEngiesOfMajorityFaction = GetMajorityFaction(toT3EngineersAndSACUs)
        elseif not table.empty(toT2Engineers) then
            toHighestTechEngiesOfMajorityFaction = GetMajorityFaction(toT2Engineers)
        elseif not table.empty(toSparkies) then
            toHighestTechEngiesOfMajorityFaction = GetMajorityFaction(toSparkies)
        elseif not table.empty(toT1Engineers) then
            toHighestTechEngiesOfMajorityFaction = GetMajorityFaction(toT1Engineers)
        end

        if toHighestTechEngiesOfMajorityFaction then
            SelectUnits(toHighestTechEngiesOfMajorityFaction)
        end
    end
end


function FilterLowestHealth()
    local toSelection = GetSelectedUnits()

    if toSelection then
        local oLowestHealthUnit
        local iLowestHealthPercent = 1.0
        local iCurHealthPercent
        for iUnit, oUnit in toSelection do
            iCurHealthPercent = oUnit:GetHealth() / oUnit:GetMaxHealth()
            if oUnit.GetFuelRatio and oUnit:GetFuelRatio() < 0.4 then
                if oUnit:GetFuelRatio() < 0.25 then
                    iCurHealthPercent = iCurHealthPercent - math.min(iCurHealthPercent * 0.5, 0.25 * (1 - oUnit:GetFuelRatio()))
                else
                    iCurHealthPercent = iCurHealthPercent - math.min(iCurHealthPercent * 0.5, 0.05 * (1 - oUnit:GetFuelRatio()))
                end
            end
            if iCurHealthPercent < iLowestHealthPercent then
                iLowestHealthPercent = iCurHealthPercent
                oLowestHealthUnit = oUnit
            end
        end
        if oLowestHealthUnit then
            SelectUnits({oLowestHealthUnit})
        end
    end
end

function SendUnitsToRefuelAtAirStaging(toUnitsToRefuel, oAirStaging)
    SelectUnits(toUnitsToRefuel)
    IssueDockCommand(true)
end

function SendSelectionToRefuel()
    local toSelection = GetSelectedUnits()
    if toSelection then
        local toUnitsToRefuel = EntityCategoryFilterDown(categories.ALLUNITS - categories.CANNOTUSEAIRSTAGING - categories.EXPERIMENTAL, toSelection)
        if not(table.empty(toUnitsToRefuel)) then
            SmartSelection.smartSelect("AIRSTAGINGPLATFORM STRUCTURE")
            local toAirStaging = GetSelectedUnits()
            --Select original units again
            SelectUnits(toSelection)
            if not(table.empty(toAirStaging)) then
                SelectUnits(toUnitsToRefuel)
                IssueDockCommand(true)
            end
            SelectUnits(toSelection)
        end
    end
end