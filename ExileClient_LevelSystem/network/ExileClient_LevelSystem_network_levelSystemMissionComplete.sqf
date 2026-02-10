/*
    Receive mission completion XP from server
    
    _this select 0: SCALAR - XP Amount
    _this select 1: STRING - Mission Name
*/

private ["_xpAmount", "_missionName"];

_xpAmount = _this select 0;
_missionName = _this select 1;

diag_log "===========================================";
diag_log "[LevelSystem Network] levelSystemMissionComplete received!";
diag_log format["  XP Amount: %1", _xpAmount];
diag_log format["  Mission: %1", _missionName];
diag_log "===========================================";

// Award XP
[_xpAmount, _missionName] call ExileClient_LevelSystem_addXP;

// Show toast notification
["SuccessTitleAndText", ["Mission Completed!", format["+%1 XP (%2)", _xpAmount, _missionName]]] call ExileClient_gui_toaster_addTemplateToast;

diag_log format["[LevelSystem] Mission XP awarded: %1 XP for %2", _xpAmount, _missionName];

// Reset AI kill counter (mission complete = new mission can start)
ExileLS_AIKills = [];

true