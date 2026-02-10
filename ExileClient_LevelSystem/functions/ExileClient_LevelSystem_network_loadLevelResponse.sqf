/*
    Receive level data from server
    
    _this select 0: SCALAR - Level
    _this select 1: SCALAR - XP
*/

private ["_level", "_xp"];

_level = _this select 0;
_xp = _this select 1;

diag_log "===========================================";
diag_log "[LevelSystem Client] loadLevelResponse received!";
diag_log format["  Player: %1", name player];
diag_log format["  Level: %1", _level];
diag_log format["  XP: %1", _xp];
diag_log "===========================================";

// ========================================
// SET ON PLAYER OBJECT (SOURCE OF TRUTH!)
// ========================================
player setVariable ["ExileLevel", _level, false];
player setVariable ["ExileXP", _xp, false];

// Also set global variables for compatibility
ExileClientPlayerLevel = _level;
ExileClientPlayerXP = _xp;

// Mark as loaded
ExileClientPlayerLevelLoaded = true;

// Update HUD
call ExileClient_LevelSystem_displayLevel;

diag_log format["[LevelSystem Client] ✅ Level data loaded for %1: Level %2, XP %3", name player, _level, _xp];

// Show welcome notification
if (ExileClientLevelSystemShowNotifications) then {
    ["SuccessTitleAndText", ["Level System", format["Welcome back! Level %1 (%2 XP)", _level, _xp]]] call ExileClient_gui_toaster_addTemplateToast;
};

true