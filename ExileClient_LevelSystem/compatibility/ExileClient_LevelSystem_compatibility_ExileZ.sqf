/*
    ExileZ Compatibility
    Hooks into ExileZ reward system to award XP for zombie kills
*/

diag_log "[LevelSystem ExileZ] Loading ExileZ compatibility...";

// ========================================
// HOOK: ExileZ Reward System
// ========================================

// Check if ExileZ is loaded
if (!isNil "ExileZ_ZombieKillReward") then {
    diag_log "[LevelSystem ExileZ] ExileZ detected! Hooking reward system...";
};

// Monitor player money for ExileZ rewards
[] spawn {
    private _lastMoney = player getVariable ["ExileMoney", 0];
    private _lastCheck = time;
    
    diag_log "[LevelSystem ExileZ] Starting money monitor for zombie rewards...";
    
    while {true} do {
        uiSleep 1;
        
        private _currentMoney = player getVariable ["ExileMoney", 0];
        private _moneyGain = _currentMoney - _lastMoney;
        
        // ExileZ typically gives money for zombie kills
        // Standard rewards are usually between 5-500 poptabs per kill
        if (_moneyGain > 0 && _moneyGain <= 1000) then {
            
            // Calculate XP based on money reward
            // Higher money reward = tougher zombie = more XP
            private _xpAmount = 0;
            
            if (_moneyGain <= 50) then {
                _xpAmount = 3; // Walker/Slow zombie
            } else if (_moneyGain <= 100) then {
                _xpAmount = 5; // Medium zombie
            } else if (_moneyGain <= 200) then {
                _xpAmount = 10; // Fast zombie
            } else if (_moneyGain <= 500) then {
                _xpAmount = 25; // Special zombie (Spider/Crawler)
            } else {
                _xpAmount = 100; // Boss zombie
            };
            
            // Award XP
            [_xpAmount, "Zombie Kill"] call ExileClient_LevelSystem_addXP;
            
            diag_log format["[LevelSystem ExileZ] Zombie reward detected: %1 poptabs -> %2 XP", _moneyGain, _xpAmount];
            
            // Update streak counter
            if (isNil "ExileLS_ZombieKillStreak") then { ExileLS_ZombieKillStreak = []; };
            ExileLS_ZombieKillStreak pushBack time;
            
            // Remove kills older than 2 minutes
            ExileLS_ZombieKillStreak = ExileLS_ZombieKillStreak select {(time - _x) < 120};
            
            private _streakCount = count ExileLS_ZombieKillStreak;
            
            // Streak bonus every 10 kills
            if (_streakCount > 0 && (_streakCount % 10) == 0) then {
                private _streakBonus = 100;
                [_streakBonus, "Zombie Streak"] call ExileClient_LevelSystem_addXP;
                
                ["SuccessTitleAndText", ["ZOMBIE MASSACRE!", format["+%1 XP Streak Bonus (%2 kills)", _streakBonus, _streakCount]]] call ExileClient_gui_toaster_addTemplateToast;
                
                diag_log format["[LevelSystem ExileZ] Streak bonus! %1 kills", _streakCount];
            };
        };
        
        _lastMoney = _currentMoney;
    };
};

// ========================================
// ALTERNATIVE: Track Zombie Deaths Directly
// ========================================
[] spawn {
    diag_log "[LevelSystem ExileZ] Starting zombie death monitor...";
    
    private _trackedZombies = [];
    
    while {true} do {
        uiSleep 2;
        
        // Get all nearby dead zombies
        private _deadZombies = (player nearEntities ["Man", 100]) select {
            !alive _x && 
            (typeOf _x find "RyanZombie" != -1) &&
            !(_x in _trackedZombies)
        };
        
        {
            private _zombie = _x;
            private _zombieType = typeOf _zombie;
            
            // Check if killed by player (distance based - if close, assume player kill)
            if (player distance _zombie < 50) then {
                
                diag_log format["[LevelSystem ExileZ] Dead zombie found: %1", _zombieType];
                
                // Determine zombie type and XP
                private _xpAmount = 5; // Default
                private _zombieName = "Zombie";
                
                // Boss
                if (_zombieType find "boss" != -1) then {
                    _xpAmount = 100;
                    _zombieName = "DEMON";
                }
                // Spider
                else if (_zombieType find "Spider" != -1) then {
                    _xpAmount = 25;
                    _zombieName = "Spider";
                }
                // Crawler
                else if (_zombieType find "Crawler" != -1) then {
                    _xpAmount = 8;
                    _zombieName = "Crawler";
                }
                // Fast
                else if (_zombieType find "Soldier" != -1 && !(_zombieType find "slow" != -1 || _zombieType find "Walker" != -1)) then {
                    _xpAmount = 20;
                    _zombieName = "Fast Soldier";
                }
                else if (!(_zombieType find "slow" != -1 || _zombieType find "medium" != -1 || _zombieType find "Walker" != -1)) then {
                    _xpAmount = 15;
                    _zombieName = "Fast Zombie";
                }
                // Medium
                else if (_zombieType find "medium" != -1) then {
                    if (_zombieType find "Soldier" != -1) then {
                        _xpAmount = 15;
                        _zombieName = "Medium Soldier";
                    } else {
                        _xpAmount = 10;
                        _zombieName = "Medium Zombie";
                    };
                }
                // Slow
                else if (_zombieType find "slow" != -1) then {
                    if (_zombieType find "Soldier" != -1) then {
                        _xpAmount = 8;
                        _zombieName = "Slow Soldier";
                    } else {
                        _xpAmount = 5;
                        _zombieName = "Slow Zombie";
                    };
                }
                // Walker
                else if (_zombieType find "Walker" != -1) then {
                    if (_zombieType find "Soldier" != -1) then {
                        _xpAmount = 5;
                        _zombieName = "Walker Soldier";
                    } else {
                        _xpAmount = 3;
                        _zombieName = "Walker";
                    };
                };
                
                // Award XP
                [_xpAmount, format["Zombie (%1)", _zombieName]] call ExileClient_LevelSystem_addXP;
                
                diag_log format["[LevelSystem ExileZ] %1 killed - %2 XP awarded", _zombieName, _xpAmount];
                
                // Mark as tracked
                _trackedZombies pushBack _zombie;
            };
            
        } forEach _deadZombies;
        
        // Cleanup old tracked zombies
        _trackedZombies = _trackedZombies select {!isNull _x && (time - (diag_tickTime)) < 300};
    };
};

diag_log "[LevelSystem ExileZ] Compatibility fully loaded (2 detection methods active)";

true