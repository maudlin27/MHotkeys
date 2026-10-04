local KeyMapper = import('/lua/keymap/keymapper.lua')
local KeyDescriptions = import('/lua/keymap/keydescriptions.lua').keyDescriptions

KeyDescriptions['mh_highestengi'] = 'Filter selection to highest tech engineers'
KeyMapper.SetUserKeyAction('mh_highestengi', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').FilterHighestTechEngineers()", category = 'selection',})

KeyDescriptions['mh_lowesthealth'] = 'Select lowest health from selection'
KeyMapper.SetUserKeyAction('mh_lowesthealth', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').FilterLowestHealth()", category = 'selection',})

KeyDescriptions['mh_refuel'] = 'Send selected unit to refuel at air staging'
KeyMapper.SetUserKeyAction('mh_refuel', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').SendSelectionToRefuel()", category = 'orders',})