private ["_playerUID", "_data", "_level", "_xp"];

_playerUID = _this;
_level = 1;
_xp = 0;

diag_log format["[LevelSystem DB] === LOAD START: %1 ===", _playerUID];

try 
{
    // Step 1: Try SELECT
    _data = format["loadPlayerLevel:%1", _playerUID] call ExileServer_system_database_query_selectSingle;
    
    diag_log format["[LevelSystem DB] SELECT returned: %1 (Type: %2, Count: %3)", 
        _data, 
        typeName _data, 
        if (typeName _data == "ARRAY") then {count _data} else {-1}
    ];
    
    // Step 2: Check if data exists
    if (!isNil "_data" && {typeName _data == "ARRAY"} && {count _data >= 2}) then 
    {
        // Data exists
        _level = _data select 0;
        _xp = _data select 1;
        diag_log format["[LevelSystem DB] ✅ Found existing: Level %1, XP %2", _level, _xp];
    }
    else 
    {
        // Step 3: No data - CREATE
        diag_log "[LevelSystem DB] ⚠️ No data found, executing INSERT...";
        
        // Execute INSERT
        format["createPlayerLevel:%1", _playerUID] call ExileServer_system_database_query_fireAndForget;
        
        diag_log "[LevelSystem DB] INSERT query sent to extDB3";
        
        // Give extDB3 time to execute
        uiSleep 0.1;
        
        // Use defaults
        _level = 1;
        _xp = 0;
        
        diag_log "[LevelSystem DB] ✅ Entry created (defaults: Level 1, XP 0)";
    };
}
catch 
{
    diag_log format["[LevelSystem DB] ❌ EXCEPTION: %1", _exception];
    _level = 1;
    _xp = 0;
};

diag_log format["[LevelSystem DB] === LOAD END: Returning [%1, %2] ===", _level, _xp];

[_level, _xp]