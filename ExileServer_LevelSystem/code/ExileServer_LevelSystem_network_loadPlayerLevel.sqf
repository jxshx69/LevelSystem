/*
    Load player level from database (Network Request)
    
    _this select 0: STRING - Session ID
    _this select 1: ARRAY - Parameters [UID]
*/

private ["_sessionID", "_parameters", "_playerUID", "_playerObject", "_data", "_level", "_xp"];

_sessionID = _this select 0;
_parameters = _this select 1;
_playerUID = _parameters select 0;

try 
{
    // Get player object
    _playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
    if (isNull _playerObject) then {
        throw "Player object not found!";
    };
    
    diag_log format["[ExileLevelSystem] Loading level data for player %1 (UID: %2)", name _playerObject, _playerUID];
    
    // Load from database
    _data = [_playerUID] call ExileServer_LevelSystem_database_loadLevel;
    
    // Extract data
    _level = _data select 0;
    _xp = _data select 1;
    
    // Set player variables (server-side)
    _playerObject setVariable ["ExileLevel", _level, true];
    _playerObject setVariable ["ExileXP", _xp, true];
    
    // Send to client
    [_sessionID, "loadLevelResponse", [_level, _xp]] call ExileServer_system_network_send_to;
    
    diag_log format["[ExileLevelSystem] Sent level data to player %1: Level %2, XP %3", name _playerObject, _level, _xp];
}
catch 
{
    diag_log format["[ExileLevelSystem] ERROR in loadPlayerLevel: %1", _exception];
    
    // Send error notification to client
    [_sessionID, "notificationRequest", ["Error", [format["Failed to load level: %1", _exception]]]] call ExileServer_system_network_send_to;
};

true