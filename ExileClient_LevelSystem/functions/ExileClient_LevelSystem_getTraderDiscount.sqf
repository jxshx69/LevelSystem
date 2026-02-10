/*
    Get trader discount based on player level
    
    Returns: SCALAR - Discount percentage
*/

private ["_level", "_discounts", "_maxLevel", "_discount"];

// Get player level
_level = player getVariable ["ExileLevel", 1];

// Fallback
if (isNil "_level" || _level < 1) then {
    _level = ExileClientPlayerLevel;
};
if (isNil "_level" || _level < 1) then {
    _level = 1;
};

// Trader Discounts per Level
_discounts = ExileClientLevelSystemTraderDiscount;

// Fallback
if (isNil "_discounts" || count _discounts == 0) then {
    _discounts = [0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,40];
};

_maxLevel = count _discounts;

// Clamp level
if (_level < 1) then { _level = 1; };
if (_level > _maxLevel) then { _level = _maxLevel; };

// Get discount
_discount = _discounts select (_level - 1);

_discount