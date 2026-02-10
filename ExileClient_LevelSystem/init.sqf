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
ExileClient_system_network_loadLevelResponse = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_system_network_loadLevelResponse.sqf";
ExileServer_LevelSystem_getLockerLimit = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileServer_LevelSystem_getLockerLimit.sqf";
ExileClient_LevelSystem_headshotDetection = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\functions\ExileClient_LevelSystem_headshotDetection.sqf";
ExileClient_LevelSystem_network_levelSystemAIKill = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\network\ExileClient_LevelSystem_network_levelSystemAIKill.sqf";
ExileClient_LevelSystem_network_levelSystemZombieKill = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\network\ExileClient_LevelSystem_network_levelSystemZombieKill.sqf";
ExileClient_LevelSystem_network_levelSystemMissionComplete = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\network\ExileClient_LevelSystem_network_levelSystemMissionComplete.sqf";
ExileClient_LevelSystem_network_loadLevelResponse = compileFinal preprocessFileLineNumbers "ExileClient_LevelSystem\network\ExileClient_LevelSystem_network_loadLevelResponse.sqf";

diag_log "ExileLevelSystem: Core functions loaded";

// Initialize Player Variables
ExileClientPlayerLevel = 1;
ExileClientPlayerXP = 0;
ExileClientPlayerLevelLoaded = false;

diag_log "ExileLevelSystem: Player variables initialized";

// ========================================
// EVENT HANDLERS
// ========================================

// Respawn Event Handler
player addEventHandler ["Respawn", {
    [] call ExileClient_LevelSystem_onRespawn;
}];

diag_log "ExileLevelSystem: Event handlers registered";

// ========================================
// BACKGROUND LOOPS
// ========================================

// Survival XP Timer (every 5 minutes)
[] spawn {
    diag_log "[LevelSystem] Survival XP loop started";
    
    while {true} do 
    {
        uiSleep 300; // 5 minutes
        
        if (alive player && ExileClientPlayerLevelLoaded) then 
        {
            ["Survival"] call ExileClient_LevelSystem_addXP;
        };
    };
};

// Apply Speed Boost Loop
[] spawn {
    diag_log "[LevelSystem] Speed boost loop started";
    
    waitUntil {!isNull player};
    uiSleep 2;
    
    while {true} do 
    {
        try 
        {
            if (alive player && ExileClientPlayerLevelLoaded) then 
            {
                private _speedBoost = call ExileClient_LevelSystem_getSpeedBoost;
                
                // Validate
                if (isNil "_speedBoost" || typeName _speedBoost != "SCALAR") then 
                {
                    _speedBoost = 1.0;
                };
                
                player setAnimSpeedCoef _speedBoost;
            };
        }
        catch 
        {
            diag_log format["[LevelSystem] Speed boost error: %1", _exception];
        };
        
        uiSleep 5;  // Check every 5 seconds
    };
};

// Display Level HUD
if (ExileClientLevelSystemShowHUD) then 
{
    [] spawn {
        diag_log "[LevelSystem] HUD loop started";
        
        // Wait for display
        uiSleep 5;
        waitUntil {uiSleep 1; !isNull (findDisplay 46)};
        uiSleep 2;
        
        // Initial display
        try 
        {
            call ExileClient_LevelSystem_displayLevel;
            diag_log "[LevelSystem] HUD initialized";
        }
        catch 
        {
            diag_log format["[LevelSystem] HUD init error: %1", _exception];
        };
        
        // Update loop
        while {true} do 
        {
            uiSleep 5;
            
            try 
            {
                if (!isNull (findDisplay 46) && ExileClientLevelSystemShowHUD) then 
                {
                    call ExileClient_LevelSystem_displayLevel;
                };
            }
            catch 
            {
                diag_log format["[LevelSystem] HUD update error: %1", _exception];
            };
        };
    };
};

diag_log "ExileLevelSystem: Background loops started";

// ========================================
// OVERRIDES (OPTIONAL - Enable if needed)
// ========================================

if (ExileClientLevelSystemEnableOverrides) then 
{
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
try 
{
    call compile preprocessFileLineNumbers "ExileClient_LevelSystem\compatibility\ExileClient_LevelSystem_compatibility_DMS.sqf";
    diag_log "ExileLevelSystem: ✅ DMS compatibility loaded";
} 
catch 
{
    diag_log format["ExileLevelSystem: ⚠️ DMS compatibility failed: %1", _exception];
};

// Occupation/VEMF Compatibility
if (!isNil "occupied_InitPlayer") then 
{
    try 
    {
        call compile preprocessFileLineNumbers "ExileClient_LevelSystem\compatibility\ExileClient_LevelSystem_compatibility_Occupation.sqf";
        diag_log "ExileLevelSystem: ✅ Occupation compatibility loaded";
    } 
    catch 
    {
        diag_log format["ExileLevelSystem: ⚠️ Occupation compatibility failed: %1", _exception];
    };
};

// ========================================
// ADMIN TOOLS (OPTIONAL - Admin only)
// ========================================

if (ExileClientLevelSystemEnableAdminTools) then 
{
    try 
    {
        call compile preprocessFileLineNumbers "ExileClient_LevelSystem\admin\ExileClient_LevelSystem_adminCommands.sqf";
        diag_log "ExileLevelSystem: ✅ Admin commands loaded";
        systemChat "Level System: Admin commands loaded! Type 'call ExileLS_Debug_ShowInfo' in debug console";
    } 
    catch 
    {
        diag_log format["ExileLevelSystem: ⚠️ Admin tools failed: %1", _exception];
    };
};

// ========================================
// DEBUG MODE (OPTIONAL - Development only)
// ========================================

if (ExileClientLevelSystemDebugMode) then 
{
    try 
    {
        call compile preprocessFileLineNumbers "ExileClient_LevelSystem\debug\ExileClient_LevelSystem_debug.sqf";
        diag_log "ExileLevelSystem: ✅ Debug mode enabled";
        systemChat "Level System: Debug mode active!";
    } 
    catch 
    {
        diag_log format["ExileLevelSystem: ⚠️ Debug tools failed: %1", _exception];
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