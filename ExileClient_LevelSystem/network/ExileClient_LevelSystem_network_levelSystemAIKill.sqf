/*
    Receive AI kill XP from server
    
    _this select 0: SCALAR - XP Amount
    _this select 1: STRING - AI Name/Type
*/

private ["_xpAmount", "_aiName"];

_xpAmount = _this select 0;
_aiName = _this select 1;

diag_log "===========================================";
diag_log "[LevelSystem Network] levelSystemAIKill received!";
diag_log format["  XP Amount: %1", _xpAmount];
diag_log format["  AI Name: %1", _aiName];
diag_log "===========================================";

// Award XP
[_xpAmount, format["AI Kill (%1)", _aiName]] call ExileClient_LevelSystem_addXP;

diag_log format["[LevelSystem] AI kill XP awarded: %1 XP for %2", _xpAmount, _aiName];

// Track AI kills for mission detection
if (isNil "ExileLS_AIKills") then { ExileLS_AIKills = []; };
ExileLS_AIKills pushBack time;
ExileLS_AIKills = ExileLS_AIKills select {(time - _x) < 600}; // Last 10 minutes

private _aiKillCount = count ExileLS_AIKills;

diag_log format["[LevelSystem] Total AI kills in last 10min: %1", _aiKillCount];

// Mission completion detection (8+ AI kills in 10 minutes)
if (_aiKillCount >= 8) then
{
	if (isNil "ExileLS_LastMissionXP") then { ExileLS_LastMissionXP = 0; };
	
	// Cooldown: Don't award mission XP more than once per 5 minutes
	if ((time - ExileLS_LastMissionXP) > 300) then
	{
		private _missionXP = 500;
		[_missionXP, "DMS Mission Complete"] call ExileClient_LevelSystem_addXP;
		
		["SuccessTitleAndText", ["Mission Completed!", format["+%1 XP Bonus", _missionXP]]] call ExileClient_gui_toaster_addTemplateToast;
		
		diag_log format["[LevelSystem] MISSION XP AWARDED: %1 XP (AI kills: %2)", _missionXP, _aiKillCount];
		
		ExileLS_LastMissionXP = time;
		ExileLS_AIKills = []; // Reset counter
	};
};

true