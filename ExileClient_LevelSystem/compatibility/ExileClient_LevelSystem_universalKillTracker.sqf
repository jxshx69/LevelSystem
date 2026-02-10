/*
    Universal Kill Tracker
    Tracks ALL deaths near player via continuous scanning
    Works even if event handlers fail
*/

diag_log "[LevelSystem] Starting Universal Kill Tracker...";

// Initialize tracking arrays
ExileLS_TrackedDeaths = [];
ExileLS_ZombieKills = [];
ExileLS_AIKills = [];
ExileLS_PlayerKills = [];

[] spawn {
    diag_log "[LevelSystem] Universal tracker spawn started";
    
    while {true} do {
        uiSleep 1;
        
        // Scan for ALL dead units within 100m
        private _allNearbyUnits = player nearEntities ["Man", 100];
        
        {
            private _unit = _x;
            
            // Only process dead units we haven't tracked yet
            if (!alive _unit && !(_unit in ExileLS_TrackedDeaths)) then {
                
                private _unitType = typeOf _unit;
                private _unitName = name _unit;
                private _distance = player distance _unit;
                
                diag_log "===========================================";
                diag_log format["[LevelSystem Tracker] DEAD UNIT FOUND!"];
                diag_log format["  Name: %1", _unitName];
                diag_log format["  Type: %1", _unitType];
                diag_log format["  Distance: %1m", round _distance];
                diag_log format["  IsPlayer: %1", isPlayer _unit];
                
                // Add to tracked list immediately
                ExileLS_TrackedDeaths pushBack _unit;
                
                // Assume player kill if within 50m (adjust as needed)
                if (_distance < 50) then {
                    
                    // ========================================
                    // ZOMBIE DETECTION
                    // ========================================
                    if (_unitType find "RyanZombie" != -1 || _unitType find "zombie" != -1) then {
                        
                        diag_log "[LevelSystem Tracker] -> ZOMBIE KILL DETECTED!";
                        
                        ExileLS_ZombieKills pushBack time;
                        
                        // Determine zombie type and XP
                        private _xpAmount = 5; // Default
                        private _zombieName = "Zombie";
                        
                        // Boss/Demon
                        if (_unitType find "boss" != -1) then {
                            _xpAmount = 100;
                            _zombieName = "DEMON";
                        }
                        // Spider
                        else if (_unitType find "Spider" != -1) then {
                            _xpAmount = 25;
                            _zombieName = "Spider";
                        }
                        // Crawler
                        else if (_unitType find "Crawler" != -1) then {
                            _xpAmount = 8;
                            _zombieName = "Crawler";
                        }
                        // Fast Soldier
                        else if (_unitType find "Soldier" != -1 && 
                                !(_unitType find "slow" != -1) && 
                                !(_unitType find "medium" != -1) && 
                                !(_unitType find "Walker" != -1)) then {
                            _xpAmount = 20;
                            _zombieName = "Fast Soldier";
                        }
                        // Fast Civilian
                        else if (!(_unitType find "slow" != -1) && 
                                !(_unitType find "medium" != -1) && 
                                !(_unitType find "Walker" != -1)) then {
                            _xpAmount = 15;
                            _zombieName = "Fast Zombie";
                        }
                        // Medium Soldier
                        else if (_unitType find "medium" != -1 && _unitType find "Soldier" != -1) then {
                            _xpAmount = 15;
                            _zombieName = "Medium Soldier";
                        }
                        // Medium Civilian
                        else if (_unitType find "medium" != -1) then {
                            _xpAmount = 10;
                            _zombieName = "Medium Zombie";
                        }
                        // Slow Soldier
                        else if (_unitType find "slow" != -1 && _unitType find "Soldier" != -1) then {
                            _xpAmount = 8;
                            _zombieName = "Slow Soldier";
                        }
                        // Slow Civilian
                        else if (_unitType find "slow" != -1) then {
                            _xpAmount = 5;
                            _zombieName = "Slow Zombie";
                        }
                        // Walker Soldier
                        else if (_unitType find "Walker" != -1 && _unitType find "Soldier" != -1) then {
                            _xpAmount = 5;
                            _zombieName = "Walker Soldier";
                        }
                        // Walker Civilian
                        else if (_unitType find "Walker" != -1) then {
                            _xpAmount = 3;
                            _zombieName = "Walker";
                        };
                        
                        // Award XP
                        [_xpAmount, format["Zombie (%1)", _zombieName]] call ExileClient_LevelSystem_addXP;
                        
                        diag_log format["[LevelSystem Tracker] XP AWARDED: %1 XP for %2", _xpAmount, _zombieName];
                        
                        // Zombie streak check
                        ExileLS_ZombieKills = ExileLS_ZombieKills select {(time - _x) < 120};
                        private _streakCount = count ExileLS_ZombieKills;
                        
                        if (_streakCount > 0 && (_streakCount % 10) == 0) then {
                            [100, "Zombie Streak"] call ExileClient_LevelSystem_addXP;
                            ["SuccessTitleAndText", ["ZOMBIE MASSACRE!", format["+100 XP Streak Bonus (%1 kills)", _streakCount]]] call ExileClient_gui_toaster_addTemplateToast;
                        };
                    }
                    
                    // ========================================
                    // PLAYER KILL DETECTION
                    // ========================================
                    else if (isPlayer _unit) then {
                        
                        diag_log "[LevelSystem Tracker] -> PLAYER KILL DETECTED!";
                        
                        ExileLS_PlayerKills pushBack time;
                        
                        private _xpAmount = 200;
                        [_xpAmount, "Player Kill"] call ExileClient_LevelSystem_addXP;
                        
                        ["SuccessTitleAndText", ["Player Kill!", format["+%1 XP", _xpAmount]]] call ExileClient_gui_toaster_addTemplateToast;
                        
                        diag_log format["[LevelSystem Tracker] XP AWARDED: %1 XP for Player Kill", _xpAmount];
                    }
                    
                    // ========================================
                    // AI KILL DETECTION (DMS, etc.)
                    // ========================================
                    else {
                        
                        diag_log "[LevelSystem Tracker] -> AI KILL DETECTED!";
                        
                        ExileLS_AIKills pushBack time;
                        
                        private _xpAmount = 50;
                        [_xpAmount, "AI Kill"] call ExileClient_LevelSystem_addXP;
                        
                        diag_log format["[LevelSystem Tracker] XP AWARDED: %1 XP for AI Kill", _xpAmount];
                        
                        // DMS Mission detection via AI kill count
                        ExileLS_AIKills = ExileLS_AIKills select {(time - _x) < 600}; // Last 10 minutes
                        private _aiKillCount = count ExileLS_AIKills;
                        
                        diag_log format["[LevelSystem Tracker] Total AI kills in last 10min: %1", _aiKillCount];
                        
                        // 8+ AI kills in 10 minutes = mission completion
                        if (_aiKillCount >= 8) then {
                            
                            // Check cooldown (don't award mission XP more than once per 5 min)
                            if (isNil "ExileLS_LastMissionXP") then { ExileLS_LastMissionXP = 0; };
                            
                            if ((time - ExileLS_LastMissionXP) > 300) then {
                                
                                private _missionXP = 500;
                                [_missionXP, "Mission Complete"] call ExileClient_LevelSystem_addXP;
                                
                                ["SuccessTitleAndText", ["Mission Completed!", format["+%1 XP Bonus", _missionXP]]] call ExileClient_gui_toaster_addTemplateToast;
                                
                                diag_log format["[LevelSystem Tracker] MISSION XP AWARDED: %1 XP (AI kills: %2)", _missionXP, _aiKillCount];
                                
                                ExileLS_LastMissionXP = time;
                                ExileLS_AIKills = []; // Reset counter
                            };
                        };
                    };
                    
                } else {
                    diag_log format["[LevelSystem Tracker] -> TOO FAR AWAY (%1m) - Not counting as player kill", round _distance];
                };
                
                diag_log "===========================================";
            };
            
        } forEach _allNearbyUnits;
        
        // Cleanup old tracked deaths (keep last 100)
        if (count ExileLS_TrackedDeaths > 100) then {
            ExileLS_TrackedDeaths = ExileLS_TrackedDeaths select [(count ExileLS_TrackedDeaths - 100), 100];
        };
    };
};

diag_log "[LevelSystem] Universal Kill Tracker ACTIVE";

true