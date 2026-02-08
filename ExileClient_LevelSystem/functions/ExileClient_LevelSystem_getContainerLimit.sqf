/*
    Get container storage money limit based on level
    Returns: NUMBER - Max poptabs in container
*/

private ["_level", "_limit"];

_level = call ExileClient_LevelSystem_getLevel;
_limit = 50000; // Default

if (_level > 0 && _level <= (count ExileClientLevelSystemContainerLimit)) then {
    _limit = ExileClientLevelSystemContainerLimit select (_level - 1);
};

_limit