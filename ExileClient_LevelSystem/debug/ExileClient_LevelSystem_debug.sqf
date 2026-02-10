/*
    Debug tools for Level System
    Execute via debug console
*/

ExileLS_Debug_ShowInfo = {
    private _info = format[
        "=== LEVEL SYSTEM DEBUG ===\n" +
        "Loaded: %1\n" +
        "Level: %2\n" +
        "XP: %3\n" +
        "Next Level XP: %4\n" +
        "Discount: %5%11\n" +
        "Speed: x%6\n" +
        "Heal: x%7\n" +
        "Locker: %8\n" +
        "Container: %9\n" +
        "HUD Visible: %10",
        ExileClientPlayerLevelLoaded,
        ExileClientPlayerLevel,
        ExileClientPlayerXP,
        if (ExileClientPlayerLevel < (count ExileClientLevelSystemXPTable)) then {ExileClientLevelSystemXPTable select ExileClientPlayerLevel} else {"MAX"},
        call ExileClient_LevelSystem_getTraderDiscount,
        call ExileClient_LevelSystem_getSpeedBoost,
        call ExileClient_LevelSystem_getHealBoost,
        call ExileClient_LevelSystem_getLockerLimit,
        call ExileClient_LevelSystem_getContainerLimit,
        ExileClientLevelSystemShowHUD,
        "%"
    ];
    
    hint _info;
    copyToClipboard _info;
};

ExileLS_Debug_TestAllXPTypes = {
    {
        private _type = _x select 0;
        [_type] call ExileClient_LevelSystem_addXP;
        uiSleep 0.5;
    } forEach ExileClientLevelSystemXPRewards;
    
    hint "Tested all XP types!";
};

ExileLS_Debug_SimulateLevelUp = {
    private _targetLevel = param [0, (ExileClientPlayerLevel + 1)];
    
    if (_targetLevel > (count ExileClientLevelSystemXPTable)) then {
        _targetLevel = count ExileClientLevelSystemXPTable;
    };
    
    ExileClientPlayerLevel = _targetLevel;
    ExileClientPlayerXP = ExileClientLevelSystemXPTable select (_targetLevel - 1);
    
    call ExileClient_LevelSystem_displayLevel;
    
    hint format["Simulated level up to %1", _targetLevel];
};

// Auto-execute on load
hint "Level System Debug Tools Loaded!\n\ncall ExileLS_Debug_ShowInfo;\ncall ExileLS_Debug_TestAllXPTypes;\n[10] call ExileLS_Debug_SimulateLevelUp;";