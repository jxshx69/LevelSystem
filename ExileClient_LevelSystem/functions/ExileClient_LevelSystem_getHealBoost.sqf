/*
    Get heal boost multiplier based on level
    Returns: NUMBER - Heal speed multiplier
*/

private ["_level", "_healBoost"];

_level = call ExileClient_LevelSystem_getLevel;
_healBoost = 1.0;

if (_level > 0 && _level <= (count ExileClientLevelSystemHealBoost)) then {
    _healBoost = ExileClientLevelSystemHealBoost select (_level - 1);
};

_healBoost