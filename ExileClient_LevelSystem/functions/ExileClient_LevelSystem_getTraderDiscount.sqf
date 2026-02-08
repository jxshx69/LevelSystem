/*
    Get trader discount based on level
    Returns: NUMBER - Discount in percent
*/

private ["_level", "_discount"];

_level = call ExileClient_LevelSystem_getLevel;
_discount = 0;

if (_level > 0 && _level <= (count ExileClientLevelSystemTraderDiscount)) then {
    _discount = ExileClientLevelSystemTraderDiscount select (_level - 1);
};

_discount