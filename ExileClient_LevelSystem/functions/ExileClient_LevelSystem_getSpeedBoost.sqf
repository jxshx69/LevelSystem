/*
    Get speed boost multiplier based on level
    Returns: NUMBER - Speed multiplier
*/

private ["_level", "_speedBoost"];

_level = call ExileClient_LevelSystem_getLevel;
_speedBoost = 1.0;

if (_level > 0 && _level <= (count ExileClientLevelSystemSpeedBoost)) then {
    _speedBoost = ExileClientLevelSystemSpeedBoost select (_level - 1);
};

_speedBoost