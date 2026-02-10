/*
    Receive level data from server
    
    _this: ARRAY - [Level, XP]
*/

private ["_level", "_xp"];

_level = _this select 0;
_xp = _this select 1;

// Set GLOBAL variables
ExileClientPlayerLevel = _level;
ExileClientPlayerXP = _xp;
ExileClientPlayerLevelLoaded = true;

// Set auf Player
player setVariable ["ExileLevel", _level, true];
player setVariable ["ExileXP", _xp, true];

diag_log format["[LevelSystem Client] ✅ Received: Level %1, XP %2", _level, _xp];

// Toast Message
["SuccessTitleAndText", ["Level geladen!", format["Level %1 - XP: %2", _level, _xp]]] call ExileClient_gui_toaster_addTemplateToast;

true