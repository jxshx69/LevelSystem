/*
    Get speed boost based on player level
    
    Returns: SCALAR - Speed multiplier
*/

private ["_level", "_speedBoosts", "_maxLevel", "_boost"];

// Get player level
_level = player getVariable ["ExileLevel", 1];

// Fallback
if (isNil "_level" || _level < 1) then {
    _level = ExileClientPlayerLevel;
};
if (isNil "_level" || _level < 1) then {
    _level = 1;
};

// Speed Boosts per Level
_speedBoosts = [];

// Try to get from global variable
if (!isNil "ExileClientLevelSystemSpeedBoost") then 
{
    _speedBoosts = ExileClientLevelSystemSpeedBoost;
};

// Fallback to default values
if (count _speedBoosts == 0) then 
{
    _speedBoosts = [
        1.0,   // Level 1
        1.02,  // Level 2
        1.04,  // Level 3
        1.06,  // Level 4
        1.08,  // Level 5
        1.1,   // Level 6
        1.12,  // Level 7
        1.14,  // Level 8
        1.16,  // Level 9
        1.18,  // Level 10
        1.2,   // Level 11
        1.22,  // Level 12
        1.24,  // Level 13
        1.26,  // Level 14
        1.28,  // Level 15
        1.3,   // Level 16
        1.32,  // Level 17
        1.34,  // Level 18
        1.36,  // Level 19
        1.4    // Level 20
    ];
};

_maxLevel = count _speedBoosts;

// Clamp level
if (_level < 1) then { _level = 1; };
if (_level > _maxLevel) then { _level = _maxLevel; };

// Get boost
_boost = _speedBoosts select (_level - 1);

_boost