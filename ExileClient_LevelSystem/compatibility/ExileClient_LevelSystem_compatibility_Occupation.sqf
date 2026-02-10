/*
    Occupation Compatibility
    Awards XP when Occupation mission is completed
*/

diag_log "[LevelSystem] Loading Occupation compatibility...";

// ========================================
// METHOD 1: Monitor Respect Increases
// ========================================
[] spawn {
    private _lastRespect = player getVariable ["ExileScore", 0];
    private _lastCheck = time;
    
    diag_log "[LevelSystem Occupation] Starting respect monitor...";
    
    while {true} do {
        uiSleep 5;
        
        private _currentRespect = player getVariable ["ExileScore", 0];
        private _respectGain = _currentRespect - _lastRespect;
        
        // Occupation typically gives 100-500 respect for mission completion
        if (_respectGain >= 100 && _respectGain <= 1000) then {
            
            // Award XP based on respect gained
            private _xpAmount = [ExileClientLevelSystemXPRewards, "MissionComplete"] call BIS_fnc_getFromPairs;
            
            // Bonus XP for higher respect gains
            if (_respectGain >= 300) then {
                _xpAmount = _xpAmount * 1.5;
            };
            
            [_xpAmount, "Occupation Mission"] call ExileClient_LevelSystem_addXP;
            
            ["SuccessTitleAndText", ["Occupation Mission!", format["+%1 XP Bonus", round _xpAmount]]] call ExileClient_gui_toaster_addTemplateToast;
            
            diag_log format["[LevelSystem Occupation] Mission detected! Respect gain: %1, XP awarded: %2", _respectGain, round _xpAmount];
            
            uiSleep 30; // Cooldown
        };
        
        _lastRespect = _currentRespect;
    };
};

// ========================================
// METHOD 2: Monitor AI Kill Streaks
// ========================================
ExileLS_Occupation_RecentKills = [];
ExileLS_Occupation_LastMissionXP = 0;

player addEventHandler ["EntityKilled", {
    params ["_killer", "_killed", "_instigator"];
    
    // Only track AI kills by player
    if (_killer == player && !isPlayer _killed && _killed isKindOf "Man") then {
        
        // Check if it's an Occupation AI
        private _isOccupationAI = false;
        
        // Occupation AI usually have specific classnames
        private _occupationClasses = [
            "O_Soldier_F", "O_soldierU_F", "O_Soldier_AR_F", 
            "O_Soldier_GL_F", "O_Soldier_M_F", "O_medic_F",
            "O_Soldier_lite_F", "O_Soldier_SL_F", "O_Soldier_TL_F"
        ];
        
        if ((typeOf _killed) in _occupationClasses) then {
            _isOccupationAI = true;
        };
        
        // Alternative: Check for Occupation variables
        if (_killed getVariable ["Occupation", false]) then {
            _isOccupationAI = true;
        };
        
        if (_isOccupationAI) then {
            
            ExileLS_Occupation_RecentKills pushBack time;
            
            // Remove kills older than 10 minutes
            ExileLS_Occupation_RecentKills = ExileLS_Occupation_RecentKills select {(time - _x) < 600};
            
            diag_log format["[LevelSystem Occupation] Occupation AI kills in last 10min: %1", count ExileLS_Occupation_RecentKills];
            
            // If 10+ Occupation AI killed in 10 minutes = mission completion
            if (count ExileLS_Occupation_RecentKills >= 10) then {
                
                // Cooldown check (don't award XP more than once per 5 minutes)
                if ((time - ExileLS_Occupation_LastMissionXP) > 300) then {
                    
                    private _xpAmount = [ExileClientLevelSystemXPRewards, "MissionComplete"] call BIS_fnc_getFromPairs;
                    [_xpAmount, "Occupation Mission"] call ExileClient_LevelSystem_addXP;
                    
                    ["SuccessTitleAndText", ["Occupation Cleared!", format["+%1 XP Bonus", _xpAmount]]] call ExileClient_gui_toaster_addTemplateToast;
                    
                    diag_log format["[LevelSystem Occupation] Mission completion detected via AI kills! Awarded %1 XP", _xpAmount];
                    
                    ExileLS_Occupation_LastMissionXP = time;
                    ExileLS_Occupation_RecentKills = []; // Reset counter
                };
            };
        };
    };
}];

diag_log "[LevelSystem Occupation] Event handlers registered";

// ========================================
// METHOD 3: Monitor Occupation Markers
// ========================================
[] spawn {
    private _knownOccupations = [];
    
    diag_log "[LevelSystem Occupation] Starting marker monitor...";
    
    while {true} do {
        uiSleep 15;
        
        // Get all Occupation markers (adjust marker names based on your Occupation config)
        private _currentOccupations = allMapMarkers select {
            _x find "Occupation" != -1 || 
            _x find "occupation" != -1 ||
            _x find "OCC_" != -1
        };
        
        // Check if any occupation disappeared (completed/cleared)
        {
            if (!(_x in _currentOccupations)) then {
                
                // Occupation marker removed = mission completed
                private _markerPos = getMarkerPos _x;
                
                // Check if player is near occupation area (within 300m)
                if (player distance _markerPos < 300) then {
                    
                    private _xpAmount = [ExileClientLevelSystemXPRewards, "MissionComplete"] call BIS_fnc_getFromPairs;
                    [_xpAmount, "Occupation Cleared"] call ExileClient_LevelSystem_addXP;
                    
                    diag_log format["[LevelSystem Occupation] Marker removed, player nearby! Awarded %1 XP", _xpAmount];
                    
                    uiSleep 30; // Cooldown
                };
            };
        } forEach _knownOccupations;
        
        _knownOccupations = _currentOccupations;
    };
};

// ========================================
// METHOD 4: Hook into Occupation Functions
// ========================================
if (!isNil "fnc_OccupationReward") then {
    diag_log "[LevelSystem Occupation] Hooking into Occupation reward function...";
    
    // Store original function
    ExileLS_Original_OccupationReward = fnc_OccupationReward;
    
    // Override with XP award
    fnc_OccupationReward = {
        // Call original function
        _this call ExileLS_Original_OccupationReward;
        
        // Award XP
        private _xpAmount = [ExileClientLevelSystemXPRewards, "MissionComplete"] call BIS_fnc_getFromPairs;
        [_xpAmount, "Occupation Reward"] call ExileClient_LevelSystem_addXP;
        
        diag_log format["[LevelSystem Occupation] Reward function triggered! Awarded %1 XP", _xpAmount];
    };
};

diag_log "[LevelSystem Occupation] Compatibility fully loaded (4 detection methods active)";

true