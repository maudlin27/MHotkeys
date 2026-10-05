local KeyMapper = import('/lua/keymap/keymapper.lua')
local KeyDescriptions = import('/lua/keymap/keydescriptions.lua').keyDescriptions

KeyDescriptions['mh_highestengi'] = 'Filter selection to highest tech engineers'
KeyMapper.SetUserKeyAction('mh_highestengi', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').FilterHighestTechEngineers()", category = 'selection',})

KeyDescriptions['mh_lowesthealth'] = 'Select lowest health single unit from selection'
KeyMapper.SetUserKeyAction('mh_lowesthealth', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').FilterLowestHealthSingleUnit()", category = 'selection',})

KeyDescriptions['mh_lowesthunits'] = 'Select lowest health units from selection'
KeyMapper.SetUserKeyAction('mh_lowesthunits', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').FilterLowestHealthUnits()", category = 'selection',})

KeyDescriptions['mh_refuel'] = 'Send selected unit to refuel at air staging'
KeyMapper.SetUserKeyAction('mh_refuel', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').SendSelectionToRefuel()", category = 'orders',})

KeyDescriptions['mh_refuelcg'] = 'Send selected unit to refuel at air staging and remove from control groups'
KeyMapper.SetUserKeyAction('mh_refuelcg', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').SendSelectionToRefuelAndRemoveFromControlGroups()", category = 'orders',})

KeyDescriptions['mh_gunships'] = 'Select all non-refueling gunships'
KeyMapper.SetUserKeyAction('mh_gunships', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').SelectAvailableGunships()", category = 'selection',})

KeyDescriptions['mh_airaa'] = 'Select all non-refueling fighters'
KeyMapper.SetUserKeyAction('mh_airaa', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').SelectAvailableAirAA()", category = 'selection',})