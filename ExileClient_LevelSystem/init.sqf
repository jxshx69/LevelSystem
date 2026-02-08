/*
    Level System Client Initialization
*/

diag_log "ExileLevelSystem: Initializing Client Functions";

// ========================================
// CONFIGURATION - ENABLE/DISABLE FEATURES
// ========================================

// Core Features (always loaded)
ExileClientLevelSystemShowNotifications = true;  // Show XP notifications
ExileClientLevelSystemShowLevelUp = true;        // Show level up message
ExileClientLevelSystemShowHUD = true;            // Show level HUD

// Optional Features (set to true to enable)
ExileClientLevelSystemEnableOverrides = true;    // Enable trader discount, heal boost, etc.
ExileClientLevelSystemEnableAdminTools = true;  // Enable admin commands (debug console)
ExileClientLevelSystemDebugMode = true;         // Enable debug tools (testing only)

// ========================================
// CORE SYSTEM (REQUIRED)
// ========================================

// Load Configuration
call compile preprocessFileLineNumbers "ExileClient_LevelSystem\config.sqf";

// Load Core Functions
ExileClient_LevelSystem_addXP = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_addXP.sqf";
ExileClient_LevelSystem_checkLevel = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_checkLevel.sqf";
ExileClient_LevelSystem_getLevel = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_getLevel.sqf";
ExileClient_LevelSystem_getTraderDiscount = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_getTraderDiscount.sqf";
ExileClient_LevelSystem_getSpeedBoost = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_getSpeedBoost.sqf";
ExileClient_LevelSystem_getHealBoost = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_getHealBoost.sqf";
ExileClient_LevelSystem_getLockerLimit = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_getLockerLimit.sqf";
ExileClient_LevelSystem_getContainerLimit = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_getContainerLimit.sqf";
ExileClient_LevelSystem_onKill = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_onKill.sqf";
ExileClient_LevelSystem_onRespawn = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_onRespawn.sqf";
ExileClient_LevelSystem_displayLevel = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_displayLevel.sqf";
ExileClient_LevelSystem_gui_xm8_show = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\code\ExileClient_LevelSystem_gui_xm8_show.sqf";
ExileClient_LevelSystem_network_loadLevelResponse = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_network_loadLevelResponse.sqf";

// Initialize Player Variables
ExileClientPlayerLevel = 1;
ExileClientPlayerXP = 0;
ExileClientPlayerLevelLoaded = false;

diag_log "ExileLevelSystem: Core functions loaded";

// ========================================
// EVENT HANDLERS
// ========================================

// Kill Event Handler
player addEventHandler ["Killed", {
    params ["_unit", "_killer"];
    if (_killer isEqualTo player) then {
        [_unit, _killer] call ExileClient_LevelSystem_onKill;
    };
}];

diag_log "ExileLevelSystem: Event handlers registered";

// ========================================
// BACKGROUND LOOPS
// ========================================

// Survival XP Timer (every 5 minutes)
[] spawn {
    while {true} do {
        uiSleep 300; // 5 minutes
        if (alive player) then {
            ["Survival"] call ExileClient_LevelSystem_addXP;
        };
    };
};

// Apply Speed Boost Loop
[] spawn {
    while {true} do {
        if (alive player && ExileClientPlayerLevelLoaded) then {
            _speedBoost = call ExileClient_LevelSystem_getSpeedBoost;
            player setAnimSpeedCoef _speedBoost;
        };
        uiSleep 1;
    };
};

// Display Level HUD (mit längerem Wait)
if (ExileClientLevelSystemShowHUD) then {
    [] spawn {
        // Wait longer for display
        uiSleep 5;
        waitUntil {uiSleep 1; !isNull (findDisplay 46)};
        uiSleep 2;
        
        // Initial display
        call ExileClient_LevelSystem_displayLevel;
        
        diag_log "[LevelSystem] HUD initialized";
        
        // Update loop
        while {true} do {
            uiSleep 5;
            
            if (!isNull (findDisplay 46) && ExileClientLevelSystemShowHUD) then {
                call ExileClient_LevelSystem_displayLevel;
            };
        };
    };
};

diag_log "ExileLevelSystem: Background loops started";

// ========================================
// OVERRIDES (OPTIONAL - Enable if needed)
// ========================================

if (ExileClientLevelSystemEnableOverrides) then {
    diag_log "ExileLevelSystem: Loading Overrides...";
    
    // Note: Overrides need to be added to CfgExileCustomCode in config.cpp
    // These are just placeholders for manual override implementation
    
    diag_log "ExileLevelSystem: Overrides enabled - Make sure to add to CfgExileCustomCode!";
    diag_log "ExileLevelSystem: Required overrides:";
    diag_log "  - ExileClient_gui_lockerDialog_show (for locker limit)";
    diag_log "  - ExileClient_object_container_store (for container limit)";
    diag_log "  - ExileClient_gui_traderDialog_updateInventoryListBox (for trader discount)";
};

// ========================================
// COMPATIBILITY (OPTIONAL - Auto-detect)
// ========================================

diag_log "ExileLevelSystem: Checking compatibility patches...";

// DMS Missions Compatibility
if (!isNil "DMS_fnc_OnKilled") then {
    try {
        call compile preprocessFileLineNumbers "ExileClient_LevelSystem\compatibility\ExileClient_LevelSystem_compatibility_DMS.sqf";
        diag_log "ExileLevelSystem: DMS compatibility loaded";
    } catch {
        diag_log format["ExileLevelSystem: DMS compatibility failed to load: %1", _exception];
    };
};

// Occupation/VEMF Compatibility
if (!isNil "occupied_InitPlayer") then {
    try {
        call compile preprocessFileLineNumbers "ExileClient_LevelSystem\compatibility\ExileClient_LevelSystem_compatibility_Occupation.sqf";
        diag_log "ExileLevelSystem: Occupation compatibility loaded";
    } catch {
        diag_log format["ExileLevelSystem: Occupation compatibility failed to load: %1", _exception];
    };
};

// ========================================
// ADMIN TOOLS (OPTIONAL - Admin only)
// ========================================

if (ExileClientLevelSystemEnableAdminTools) then {
    try {
        call compile preprocessFileLineNumbers "ExileClient_LevelSystem\admin\ExileClient_LevelSystem_adminCommands.sqf";
        diag_log "ExileLevelSystem: Admin commands loaded";
        systemChat "Level System: Admin commands loaded! Type 'call ExileLS_Debug_ShowInfo' in debug console";
    } catch {
        diag_log format["ExileLevelSystem: Admin tools failed to load: %1", _exception];
    };
};

// ========================================
// DEBUG MODE (OPTIONAL - Development only)
// ========================================

if (ExileClientLevelSystemDebugMode) then {
    try {
        call compile preprocessFileLineNumbers "ExileClient_LevelSystem\debug\ExileClient_LevelSystem_debug.sqf";
        diag_log "ExileLevelSystem: Debug mode enabled";
        systemChat "Level System: Debug mode active!";
    } catch {
        diag_log format["ExileLevelSystem: Debug tools failed to load: %1", _exception];
    };
};

// ========================================
// FINALIZATION
// ========================================

diag_log "===========================================";
diag_log "ExileLevelSystem: Client fully initialized";
diag_log format["  Notifications: %1", ExileClientLevelSystemShowNotifications];
diag_log format["  Level Up Toast: %1", ExileClientLevelSystemShowLevelUp];
diag_log format["  HUD Display: %1", ExileClientLevelSystemShowHUD];
diag_log format["  Overrides: %1", ExileClientLevelSystemEnableOverrides];
diag_log format["  Admin Tools: %1", ExileClientLevelSystemEnableAdminTools];
diag_log format["  Debug Mode: %1", ExileClientLevelSystemDebugMode];
diag_log "===========================================";

true