/*
    Load player level from database (Network Request)
    
    _this select 0: STRING - Session ID
    _this select 1: ARRAY - Parameters (empty array)
*/

private ["_sessionID", "_params", "_playerObject", "_playerUID", "_data", "_level", "_xp"];

_sessionID = _this select 0;
_params = _this select 1;

try 
{
    diag_log format["[LevelSystem Server] === LOAD REQUEST START ==="];
    diag_log format["[LevelSystem Server] SessionID: %1", _sessionID];
    
    // Get player object from session
    _playerObject = _sessionID call ExileServer_system_session_getPlayerObject;
    
    // Validate player object
    if (isNull _playerObject) then {
        throw "Player object is null!";
    };
    
    // Get UID from player object (NOT from params!)
    _playerUID = getPlayerUID _playerObject;
    
    diag_log format["[LevelSystem Server] Player: %1 | UID: %2", name _playerObject, _playerUID];
    
    // Load from database
    _data = _playerUID call ExileServer_LevelSystem_database_loadLevel;
    
    // Validate database response
    if (isNil "_data" || {typeName _data != "ARRAY"} || {count _data < 2}) then {
        throw format["Invalid database response: %1", _data];
    };
    
    // Extract data
    _level = _data select 0;
    _xp = _data select 1;
    
    diag_log format["[LevelSystem Server] DB returned: Level %1, XP %2", _level, _xp];
    
    // Set player variables (server-side) with PUBLIC flag
    _playerObject setVariable ["ExileLevel", _level, true];
    _playerObject setVariable ["ExileXP", _xp, true];
    
    diag_log format["[LevelSystem Server] Variables set on server for %1", name _playerObject];
    
    // Send to THIS CLIENT ONLY
    [_sessionID, "loadLevelResponse", [_level, _xp]] call ExileServer_system_network_send_to;
    
    diag_log format["[LevelSystem Server] ✅ Sent to client: Level %1, XP %2", _level, _xp];
    diag_log "[LevelSystem Server] === LOAD REQUEST END ===";
}
catch 
{
    diag_log format["[LevelSystem Server] ❌ ERROR: %1", _exception];
    
    // Send default values on error
    [_sessionID, "loadLevelResponse", [1, 0]] call ExileServer_system_network_send_to;
    
    // Also send error toast
    [_sessionID, "toastRequest", ["ErrorTitleAndText", ["Level System", format["Load error: %1", _exception]]]] call ExileServer_system_network_send_to;
};

true