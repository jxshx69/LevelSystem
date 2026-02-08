/*
    ExileServer_LevelSystem - server addon bootstrap
    Compiles functions into missionNamespace (server).
*/

diag_log "===========================================";
diag_log "[ExileServer_LevelSystem] Starting preInit...";
diag_log "===========================================";

private _compile = {
    params ["_fn", "_path"];
    
    diag_log format["[ExileServer_LevelSystem] Compiling: %1", _fn];
    
    private _code = compileFinal (preprocessFileLineNumbers _path);
    missionNamespace setVariable [_fn, _code];
    
    diag_log format["[ExileServer_LevelSystem]   ✅ Loaded: %1", _fn];
};

[
    ["ExileServer_LevelSystem_database_loadLevel", "ExileServer_LevelSystem\code\ExileServer_LevelSystem_database_loadLevel.sqf"],
    ["ExileServer_LevelSystem_database_saveLevel", "ExileServer_LevelSystem\code\ExileServer_LevelSystem_database_saveLevel.sqf"],
    ["ExileServer_LevelSystem_network_loadPlayerLevel", "ExileServer_LevelSystem\code\ExileServer_LevelSystem_network_loadPlayerLevel.sqf"],
    ["ExileServer_LevelSystem_network_savePlayerLevel", "ExileServer_LevelSystem\code\ExileServer_LevelSystem_network_savePlayerLevel.sqf"]
] apply { _x call _compile };

diag_log "===========================================";
diag_log "[ExileServer_LevelSystem] All functions compiled";
diag_log "===========================================";

// Verify functions exist
{
    if (isNil _x) then {
        diag_log format["[ExileServer_LevelSystem] ❌ MISSING: %1", _x];
    } else {
        diag_log format["[ExileServer_LevelSystem] ✅ Verified: %1", _x];
    };
} forEach [
    "ExileServer_LevelSystem_database_loadLevel",
    "ExileServer_LevelSystem_database_saveLevel",
    "ExileServer_LevelSystem_network_loadPlayerLevel",
    "ExileServer_LevelSystem_network_savePlayerLevel"
];

diag_log "===========================================";
diag_log "[ExileServer_LevelSystem] ✅ preInit complete!";
diag_log "===========================================";

true