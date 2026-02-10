/*
    Get current player level
    Reads from PLAYER OBJECT (not global variable)
    
    Returns: SCALAR - Player Level
*/

private ["_level"];

// ALWAYS read from player object first (this is the source of truth)
_level = player getVariable ["ExileLevel", -1];

// If not found on player object, try local variable
if (_level < 1) then {
    if (!isNil "ExileClientPlayerLevel" && {ExileClientPlayerLevel > 0}) then {
        _level = ExileClientPlayerLevel;
        
        // Sync back to player object
        player setVariable ["ExileLevel", _level, false];
        
        diag_log format["[LevelSystem] getLevel: Synced local var to player object: %1", _level];
    } else {
        // Default
        _level = 1;
        
        diag_log "[LevelSystem] getLevel: Using default level 1";
    };
};

// Always update local variable to match player object
ExileClientPlayerLevel = _level;

_level