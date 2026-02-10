/*
    Receive level data from server
    ONLY process if it's for THIS player!
    
    _this select 0: SCALAR - Level
    _this select 1: SCALAR - XP
*/

private ["_level", "_xp"];

_level = _this select 0;
_xp = _this select 1;

diag_log "===========================================";
diag_log "[LevelSystem Client] loadLevelResponse received!";
diag_log format["  My Name: %1", name player];
diag_log format["  My Current Level: %1", player getVariable ["ExileLevel", -1]];
diag_log format["  My Current XP: %1", player getVariable ["ExileXP", -1]];
diag_log format["  Received Level: %1", _level];
diag_log format["  Received XP: %1", _xp];
diag_log "===========================================";

// ========================================
// CRITICAL: Check if this is OUR data!
// ========================================

// If we already have level data loaded, ignore incoming data from other players
if (!isNil "ExileClientPlayerLevelLoaded" && {ExileClientPlayerLevelLoaded}) exitWith 
{
    private _myCurrentLevel = player getVariable ["ExileLevel", -1];
    private _myCurrentXP = player getVariable ["ExileXP", -1];
    
    // If our data is already set and different from incoming, it's probably for another player
    if (_myCurrentLevel > 0 && _myCurrentXP >= 0) then 
    {
        if (_myCurrentLevel != _level || _myCurrentXP != _xp) exitWith 
        {
            diag_log "[LevelSystem Client] ⚠️ WARNING: Ignoring loadLevelResponse - already loaded with different data!";
            diag_log format["  Our data: Level %1, XP %2", _myCurrentLevel, _myCurrentXP];
            diag_log format["  Incoming: Level %1, XP %2", _level, _xp];
            diag_log "[LevelSystem Client] This message is probably for another player joining!";
            
            true  // Exit without changing anything
        };
    };
    
    // Data is the same as we already have, update anyway
    diag_log "[LevelSystem Client] Data matches existing, updating...";
};

// ========================================
// SET ON PLAYER OBJECT (SOURCE OF TRUTH!)
// ========================================
player setVariable ["ExileLevel", _level, false];
player setVariable ["ExileXP", _xp, false];

// Also set local variables for compatibility
ExileClientPlayerLevel = _level;
ExileClientPlayerXP = _xp;

// Mark as loaded
ExileClientPlayerLevelLoaded = true;

// Update HUD
call ExileClient_LevelSystem_displayLevel;

diag_log format["[LevelSystem Client] ✅ Level data loaded for %1: Level %2, XP %3", name player, _level, _xp];

// Show welcome notification
if (ExileClientLevelSystemShowNotifications) then 
{
    ["SuccessTitleAndText", ["Level System", format["Welcome back! Level %1 (%2 XP)", _level, _xp]]] call ExileClient_gui_toaster_addTemplateToast;
};

true