/*
    Get locker limit based on player level
    Can be called with or without parameter
    
    Optional parameter:
    _this select 0: SCALAR - Player Level (if not provided, uses current player level)
    
    Returns: SCALAR - Locker Limit
*/

private ["_level", "_lockerLimits", "_maxLevel", "_limit"];

// Get level from parameter or current player level
if (count _this > 0) then {
    _level = _this select 0;
} else {
    // Get current player level
    _level = call ExileClient_LevelSystem_getLevel;
};

// Locker Limits per Level
_lockerLimits = [
    500000,1000000,1500000,2000000,2500000,3000000,3500000,4000000,4500000,5000000,
    5500000,6000000,6500000,7000000,7500000,8000000,8500000,9000000,10000000,15000000
];

_maxLevel = count _lockerLimits;

// Clamp level
if (_level < 1) then { _level = 1; };
if (_level > _maxLevel) then { _level = _maxLevel; };

// Get limit (level - 1 because arrays start at 0)
_limit = _lockerLimits select (_level - 1);

diag_log format["[LevelSystem] getLockerLimit: Level %1 -> Limit %2", _level, _limit];

_limit