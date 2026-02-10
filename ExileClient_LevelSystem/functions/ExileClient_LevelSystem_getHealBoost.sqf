/*
    Get heal boost based on player level
    
    Returns: SCALAR - Heal multiplier
*/

private ["_level", "_healBoosts", "_maxLevel", "_boost"];

// Get player level
_level = player getVariable ["ExileLevel", 1];

// Fallback
if (isNil "_level" || _level < 1) then {
    _level = ExileClientPlayerLevel;
};
if (isNil "_level" || _level < 1) then {
    _level = 1;
};

// Heal Boosts per Level
_healBoosts = ExileClientLevelSystemHealBoost;

// Fallback
if (isNil "_healBoosts" || count _healBoosts == 0) then {
    _healBoosts = [1.0,1.05,1.1,1.15,1.2,1.25,1.3,1.35,1.4,1.45,1.5,1.55,1.6,1.65,1.7,1.75,1.8,1.85,1.9,2.0];
};

_maxLevel = count _healBoosts;

// Clamp level
if (_level < 1) then { _level = 1; };
if (_level > _maxLevel) then { _level = _maxLevel; };

// Get boost
_boost = _healBoosts select (_level - 1);

_boost