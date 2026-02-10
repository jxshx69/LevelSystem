/*
    Load player level from database
    
    _this: STRING - Player UID
    
    Returns: ARRAY - [Level, XP]
*/

private ["_playerUID", "_data", "_level", "_xp"];

_playerUID = _this;
_level = 1;
_xp = 0;

diag_log "========================================";
diag_log "[LevelSystem DB] LOAD START";
diag_log format["  UID: %1", _playerUID];

try 
{
    // Step 1: Check if account exists
    diag_log "[LevelSystem DB] Step 1: Checking if account exists...";
    
    private _hasAccount = format["hasLevelAccount:%1", _playerUID] call ExileServer_system_database_query_selectSingleField;
    
    diag_log format["  Result: %1 (Type: %2)", _hasAccount, typeName _hasAccount];
    
    if (isNil "_hasAccount" || _hasAccount != "true") then 
    {
        // Step 2: Create account
        diag_log "[LevelSystem DB] Step 2: No account found, creating...";
        
        format["createPlayerLevel:%1", _playerUID] call ExileServer_system_database_query_fireAndForget;
        
        diag_log "[LevelSystem DB] ✅ Account created, returning defaults";
        
        _level = 1;
        _xp = 0;
    }
    else
    {
        // Step 3: Load data
        diag_log "[LevelSystem DB] Step 3: Account exists, loading data...";
        
        _data = format["loadPlayerLevel:%1", _playerUID] call ExileServer_system_database_query_selectSingle;
        
        diag_log format["  Query result: %1", _data];
        diag_log format["  Type: %1", typeName _data];
        
        if (!isNil "_data" && {typeName _data == "ARRAY"} && {count _data >= 2}) then 
        {
            _level = _data select 0;
            _xp = _data select 1;
            
            diag_log format["  ✅ Loaded: Level %1, XP %2", _level, _xp];
        }
        else
        {
            diag_log "  ⚠️ Invalid data returned, using defaults";
            _level = 1;
            _xp = 0;
        };
    };
}
catch 
{
    diag_log "========================================";
    diag_log "[LevelSystem DB] ❌ EXCEPTION!";
    diag_log format["  Exception: %1", _exception];
    diag_log "========================================";
    
    _level = 1;
    _xp = 0;
};

diag_log "========================================";
diag_log format["[LevelSystem DB] LOAD END: [%1, %2]", _level, _xp];
diag_log "========================================";

[_level, _xp]