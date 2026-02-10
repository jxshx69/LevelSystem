/*
    Save player level to database (Network Request)
    
    _this select 0: STRING - Session ID
    _this select 1: ARRAY - Parameters [Level, XP]
*/

private ["_sessionID", "_parameters", "_level", "_xp", "_playerObject", "_playerUID"];

_sessionID = _this select 0;
_parameters = _this select 1;
_level = _parameters select 0;
_xp = _parameters select 1;

try 
{
    diag_log format["[LevelSystem] saveLevelRequest - SessionID: %1, Level: %2, XP: %3", _sessionID, _level, _xp];
    
    // Get player object from session
    _playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
    
    // Validate player object
    if (isNull _playerObject) then {
        throw "Player object is null!";
    };
    
    // Get player UID
    _playerUID = getPlayerUID _playerObject;
    
    diag_log format["[ExileLevelSystem] Saving level data for player %1 (UID: %2): Level %3, XP %4", name _playerObject, _playerUID, _level, _xp];
    
    // Save to database
    [_playerUID, _level, _xp] call ExileServer_LevelSystem_database_saveLevel;
    
    // Update player variables (server-side)
    _playerObject setVariable ["ExileLevel", _level, true];
    _playerObject setVariable ["ExileXP", _xp, true];
    
    diag_log format["[ExileLevelSystem] ✅ Successfully saved level data for player %1", name _playerObject];
}
catch 
{
    diag_log format["[ExileLevelSystem] ❌ ERROR in savePlayerLevel: %1", _exception];
    
    // Send error notification to client (use sessionID, not owner)
    [_sessionID, "toastRequest", ["ErrorTitleAndText", ["Level System Error", format["Failed to save level: %1", _exception]]]] call ExileServer_system_network_send_to;
};

true