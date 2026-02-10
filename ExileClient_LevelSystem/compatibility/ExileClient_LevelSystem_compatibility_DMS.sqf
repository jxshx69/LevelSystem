/*
    DMS Mission Detection - Simplified
    Tracks AI kills near mission areas
*/

diag_log "[LevelSystem DMS] Loading simple mission detection...";

ExileLS_DMS_TrackedAI = [];
ExileLS_DMS_RecentKills = [];
ExileLS_DMS_LastMissionXP = 0;

[] spawn {
    while {true} do {
        uiSleep 3;
        
        // Find dead AI near player
        private _deadAI = (player nearEntities ["Man", 150]) select {
            !alive _x && 
            !isPlayer _x && 
            (typeOf _x find "RyanZombie" == -1) && // Not a zombie
            !(_x in ExileLS_DMS_TrackedAI)
        };
        
        {
            private _ai = _x;
            
            diag_log format["[LevelSystem DMS] Dead AI found: %1", typeOf _ai];
            
            // Add to tracked
            ExileLS_DMS_TrackedAI pushBack _ai;
            ExileLS_DMS_RecentKills pushBack time;
            
        } forEach _deadAI;
        
        // Remove old kills (older than 10 minutes)
        ExileLS_DMS_RecentKills = ExileLS_DMS_RecentKills select {(time - _x) < 600};
        
        private _killCount = count ExileLS_DMS_RecentKills;
        
        // Mission completion: 8+ AI kills in 10 minutes
        if (_killCount >= 8 && (time - ExileLS_DMS_LastMissionXP) > 300) then {
            
            private _xpAmount = 500;
            [_xpAmount, "Mission"] call ExileClient_LevelSystem_addXP;
            
            ["SuccessTitleAndText", ["Mission Completed!", format["+%1 XP Bonus", _xpAmount]]] call ExileClient_gui_toaster_addTemplateToast;
            
            diag_log format["[LevelSystem DMS] Mission completion detected! %1 AI kills", _killCount];
            
            ExileLS_DMS_LastMissionXP = time;
            ExileLS_DMS_RecentKills = [];
        };
        
        // Cleanup
        ExileLS_DMS_TrackedAI = ExileLS_DMS_TrackedAI select {!isNull _x};
    };
};

diag_log "[LevelSystem DMS] Simple mission detection loaded";

true