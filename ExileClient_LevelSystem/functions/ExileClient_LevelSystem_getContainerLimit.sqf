/*
    Get container limit based on player level
    
    Returns: SCALAR - Container limit
*/

private ["_level", "_containerLimits", "_maxLevel", "_limit"];

// Get player level
_level = player getVariable ["ExileLevel", 1];

// Fallback
if (isNil "_level" || _level < 1) then {
    _level = ExileClientPlayerLevel;
};
if (isNil "_level" || _level < 1) then {
    _level = 1;
};

// Container Limits per Level
_containerLimits = ExileClientLevelSystemContainerLimit;

// Fallback
if (isNil "_containerLimits" || count _containerLimits == 0) then {
    _containerLimits = [50000,75000,100000,125000,150000,200000,250000,325000,400000,500000,625000,750000,900000,1050000,1250000,1500000,1750000,2000000,2500000,5000000];
};

_maxLevel = count _containerLimits;

// Clamp level
if (_level < 1) then { _level = 1; };
if (_level > _maxLevel) then { _level = _maxLevel; };

// Get limit
_limit = _containerLimits select (_level - 1);

_limit