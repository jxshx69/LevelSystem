/*
    Level System Admin Panel für XM8
    Zeigt Admin-Optionen im XM8 an
*/

// =========================================
// XM8 APP REGISTRIERUNG
// =========================================
private _appName = "Level Admin";
private _iconPath = "\exile_assets\texture\ui\xm8\exile_xm8_apps_tile_default_ca.paa"; // Standard Icon

// XM8 App registrieren
[
    _appName,           // App Name
    _iconPath,          // Icon Pfad
    {
        // OnClick Code - wird ausgeführt wenn App geklickt wird
        [] call compile preprocessFileLineNumbers "ExileClient_LevelSystem\admin\XM8_LevelSystemAdmin_Dialog.sqf";
    }
] call ExileClient_gui_xm8_fnc_addApp;

// =========================================
// ADMIN FUNKTIONEN
// =========================================

// SET LEVEL
ExileLS_SetLevel = {
    params ["_level"];
    
    if (isNil "_level" || _level < 1 || _level > 20) exitWith {
        hint "ERROR: Invalid level (1-20)";
        false
    };
    
    ExileClientPlayerLevel = _level;
    
    if (_level > 1) then {
        ExileClientPlayerXP = ExileClientLevelSystemXPTable select (_level - 1);
    } else {
        ExileClientPlayerXP = 0;
    };
    
    call ExileClient_LevelSystem_displayLevel;
    
    ["saveLevelRequest", [ExileClientPlayerLevel, ExileClientPlayerXP]] call ExileClient_system_network_send;
    
    ["Success", [format["Level set to %1", _level]]] call ExileClient_gui_toaster_addTemplateToast;
    
    diag_log format["[LevelSystem Admin] Set level to %1, XP %2", _level, ExileClientPlayerXP];
    
    true
};

// ADD XP
ExileLS_AddXP = {
    params ["_amount"];
    
    if (isNil "_amount" || _amount < 1) exitWith {
        hint "ERROR: Invalid XP amount";
        false
    };
    
    ["Admin", _amount] call ExileClient_LevelSystem_addXP;
    
    true
};

// RESET LEVEL
ExileLS_ResetLevel = {
    ExileClientPlayerLevel = 1;
    ExileClientPlayerXP = 0;
    
    call ExileClient_LevelSystem_displayLevel;
    
    ["saveLevelRequest", [1, 0]] call ExileClient_system_network_send;
    
    ["Success", ["Level reset to 1"]] call ExileClient_gui_toaster_addTemplateToast;
    
    diag_log "[LevelSystem Admin] Level reset to 1";
    
    true
};

// SHOW BONUSES
ExileLS_ShowBonuses = {
    private ["_level", "_discount", "_speed", "_heal", "_locker", "_container"];
    
    _level = call ExileClient_LevelSystem_getLevel;
    _discount = call ExileClient_LevelSystem_getTraderDiscount;
    _speed = call ExileClient_LevelSystem_getSpeedBoost;
    _heal = call ExileClient_LevelSystem_getHealBoost;
    _locker = call ExileClient_LevelSystem_getLockerLimit;
    _container = call ExileClient_LevelSystem_getContainerLimit;
    
    hint parseText format[
        "<t align='center' size='1.2' color='#FFD700'>LEVEL %1 BONUSES</t><br/>" +
        "<t align='left' size='0.8'>" +
        "Trader Discount: <t color='#00FF00'>%2%%</t><br/>" +
        "Speed Boost: <t color='#00FF00'>x%3</t><br/>" +
        "Heal Boost: <t color='#00FF00'>x%4</t><br/>" +
        "Locker Limit: <t color='#FFD700'>%5</t><br/>" +
        "Container Limit: <t color='#FFD700'>%6</t><br/>" +
        "Current XP: <t color='#FFFFFF'>%7</t>" +
        "</t>",
        _level, _discount, _speed, _heal, _locker, _container, ExileClientPlayerXP
    ];
    
    true
};

diag_log "[LevelSystem] XM8 Admin App registered successfully!";

true