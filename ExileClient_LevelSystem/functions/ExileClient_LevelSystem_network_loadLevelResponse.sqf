/*
    Handle player respawn - reapply level bonuses
*/

// Request level data from server
["loadLevelRequest", [getPlayerUID player]] call ExileClient_system_network_send;

// Wait for data to load
waitUntil {ExileClientPlayerLevelLoaded};

// Reapply speed boost
_speedBoost = call ExileClient_LevelSystem_getSpeedBoost;
player setAnimSpeedCoef _speedBoost;

// Display level
if (ExileClientLevelSystemShowHUD) then {
    call ExileClient_LevelSystem_displayLevel;
};

diag_log format["ExileLevelSystem: Player respawned - Level %1, XP %2", ExileClientPlayerLevel, ExileClientPlayerXP];

true