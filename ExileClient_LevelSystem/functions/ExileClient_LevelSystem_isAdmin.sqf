/*
    Check if player is Level System Admin
    
    Returns: BOOL - true if admin, false if not
*/

private ["_playerUID", "_adminUIDs", "_isAdmin"];

_playerUID = getPlayerUID player;
_isAdmin = false;

// Get admin UIDs from config
_adminUIDs = getArray (missionConfigFile >> "CfgLevelSystemAdmin" >> "adminUIDs");

// Check if player UID is in admin list
if (_playerUID in _adminUIDs) then {
    _isAdmin = true;
    diag_log format["[LevelSystem] Admin access granted for UID: %1", _playerUID];
} else {
    diag_log format["[LevelSystem] Admin access DENIED for UID: %1", _playerUID];
};

_isAdmin