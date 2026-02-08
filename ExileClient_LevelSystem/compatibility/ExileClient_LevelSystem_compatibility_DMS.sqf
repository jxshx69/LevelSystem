/*
    Compatibility with DMS Missions
    Awards XP on mission completion
*/

// Hook into DMS mission completion
if (!isNil "DMS_fnc_OnKilled") then {
    DMS_fnc_OnKilled_Original = DMS_fnc_OnKilled;
    
    DMS_fnc_OnKilled = {
        _result = _this call DMS_fnc_OnKilled_Original;
        
        // Award mission XP
        if (_result) then {
            ["MissionComplete"] call ExileClient_LevelSystem_addXP;
        };
        
        _result
    };
    
    diag_log "[ExileLevelSystem] DMS Compatibility loaded";
};

true