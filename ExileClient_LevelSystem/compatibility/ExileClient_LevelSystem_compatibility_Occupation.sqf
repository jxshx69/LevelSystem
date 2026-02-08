/*
    Compatibility with Occupation/VEMF/etc AI spawners
    Ensures AI kills are tracked
*/

// Add event handler for AI kills
if (!isNil "occupied_InitPlayer") then {
    [] spawn {
        waitUntil {!isNull player};
        
        player addEventHandler ["Killed", {
            params ["_unit", "_killer", "_instigator", "_useEffects"];
            
            if (_killer isEqualTo player || _instigator isEqualTo player) then {
                if (!isPlayer _unit) then {
                    [_unit, player] call ExileClient_LevelSystem_onKill;
                };
            };
        }];
    };
    
    diag_log "[ExileLevelSystem] Occupation Compatibility loaded";
};

true