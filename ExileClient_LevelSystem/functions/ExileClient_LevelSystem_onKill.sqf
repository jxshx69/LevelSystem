/*
    Handle kill events and award XP
    
    _this select 0: OBJECT - Killed unit
    _this select 1: OBJECT - Killer
*/

private ["_killedUnit", "_killer", "_xpType", "_isHeadshot", "_bonusXP"];

_killedUnit = _this select 0;
_killer = _this select 1;
_xpType = "";
_bonusXP = 0;

// Check if it's a player kill or AI kill
if (isPlayer _killedUnit) then {
    _xpType = "PlayerKill";
} else {
    _xpType = "AIKill";
};

// Check for headshot
_isHeadshot = false;
if (damage (_killedUnit select ["head", 0]) >= 1) then {
    _isHeadshot = true;
    _bonusXP = {if ((_x select 0) isEqualTo "Headshot") exitWith {_x select 1}; 0} forEach ExileClientLevelSystemXPRewards;
};

// Award XP for kill
[_xpType] call ExileClient_LevelSystem_addXP;

// Award bonus XP for headshot
if (_isHeadshot) then {
    ["Headshot", _bonusXP] call ExileClient_LevelSystem_addXP;
};

// Check if killed unit was in a vehicle
_vehicle = vehicle _killedUnit;
if (!isNull _vehicle && _vehicle != _killedUnit) then {
    ["VehicleKill"] call ExileClient_LevelSystem_addXP;
};

true