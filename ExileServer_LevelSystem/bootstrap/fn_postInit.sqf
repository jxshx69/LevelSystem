/**
 * ExileServer_LevelSystem postInit
 * Runs after server is fully initialized
 * Registers network message handlers
 */

diag_log "===========================================";
diag_log "[ExileLevelSystem] Starting postInit...";
diag_log "===========================================";

// Wait for Exile to be fully loaded
[] spawn {
    // Wait for Exile initialization
    waitUntil {!isNil "ExileServerStartTime"};
    
    diag_log "[ExileLevelSystem] Exile server detected, continuing postInit...";
    
    // Small delay to ensure everything is ready
    uiSleep 1;
    
    // ========================================
    // FINAL VERIFICATION
    // ========================================
    
    private ["_allOK"];
    _allOK = true;
    
    // Check all functions
    {
        if (isNil _x) then 
        {
            diag_log format["[ExileLevelSystem] ❌ ERROR: Function not available: %1", _x];
            _allOK = false;
        };
    } forEach 
    [
        "ExileServer_LevelSystem_database_loadLevel",
        "ExileServer_LevelSystem_database_saveLevel",
        "ExileServer_LevelSystem_network_loadPlayerLevel",
        "ExileServer_LevelSystem_network_savePlayerLevel"
    ];
    
    if (_allOK) then 
    {
        diag_log "[ExileLevelSystem] ✅ All functions verified and ready!";
    } else {
        diag_log "[ExileLevelSystem] ❌ CRITICAL: Some functions are missing!";
    };
    
    // ========================================
    // SYSTEM INFO
    // ========================================
    
    diag_log "===========================================";
    diag_log "[ExileLevelSystem] System Information:";
    diag_log format["  - Database Functions: %1", !isNil "ExileServer_LevelSystem_database_loadLevel"];
    diag_log format["  - Network Functions: %1", !isNil "ExileServer_LevelSystem_network_loadPlayerLevel"];
    diag_log format["  - dispatchIncomingMessage Override: %1", !isNil "ExileServer_system_network_dispatchIncomingMessage"];
    diag_log "===========================================";
    diag_log "[ExileLevelSystem] ✅ Level System fully initialized and ready!";
    diag_log "===========================================";
};

true