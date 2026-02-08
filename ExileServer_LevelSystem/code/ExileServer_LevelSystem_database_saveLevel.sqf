/*
    Save player level to database (extDB3)
    
    _this select 0: STRING - Player UID
    _this select 1: NUMBER - Level
    _this select 2: NUMBER - XP
*/

private ["_playerUID", "_level", "_xp"];

_playerUID = _this select 0;
_level = _this select 1;
_xp = _this select 2;

try 
{
    // Validate inputs
    if (isNil "_playerUID" || _playerUID isEqualTo "") then {
        throw "Invalid player UID";
    };
    
    if (isNil "_level" || _level < 1) then {
        throw "Invalid level value";
    };
    
    if (isNil "_xp" || _xp < 0) then {
        throw "Invalid XP value";
    };
    
    // Update database using extDB3
    format["updatePlayerLevel:%1:%2:%3", _level, _xp, _playerUID] call ExileServer_system_database_query_fireAndForget;
    
    diag_log format["[ExileLevelSystem] Saved level data for UID %1: Level %2, XP %3", _playerUID, _level, _xp];
}
catch 
{
    diag_log format["[ExileLevelSystem] ERROR saving level for UID %1: %2", _playerUID, _exception];
};

true