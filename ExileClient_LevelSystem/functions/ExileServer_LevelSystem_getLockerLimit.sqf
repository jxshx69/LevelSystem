/*
    Get locker limit based on player level (SERVER-SIDE)
    
    _this select 0: SCALAR - Player Level
    
    Returns: SCALAR - Locker Limit
*/

private ["_level", "_lockerLimits", "_maxLevel", "_limit"];

_level = _this select 0;

// Locker Limits per Level (same as client config)
_lockerLimits = [
    100000,150000,200000,250000,300000,400000,500000,650000,800000,1000000,
    1250000,1500000,1800000,2100000,2500000,3000000,3500000,4000000,5000000,10000000
];

_maxLevel = count _lockerLimits;

// Clamp level
if (_level < 1) then { _level = 1; };
if (_level > _maxLevel) then { _level = _maxLevel; };

// Get limit (level - 1 because arrays start at 0)
_limit = _lockerLimits select (_level - 1);

diag_log format["[LevelSystem Server] getLockerLimit: Level %1 -> Limit %2", _level, _limit];

_limit