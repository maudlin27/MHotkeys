local KeyMapper = import('/lua/keymap/keymapper.lua')
local KeyDescriptions = import('/lua/keymap/keydescriptions.lua').keyDescriptions

KeyDescriptions['highestengi'] = 'Select highest tech engineers'
KeyMapper.SetUserKeyAction('highestengi', {action = "UI_Lua import('/mods/MHotkeys/lua/actions.lua').FilterHighestTechEngineers()", category = 'orders', order = 35,})