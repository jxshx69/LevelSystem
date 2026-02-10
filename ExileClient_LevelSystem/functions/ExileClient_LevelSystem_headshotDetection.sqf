/*
    Advanced Headshot Detection System
*/

diag_log "[LevelSystem] Loading headshot detection...";

// Monitor all units for headshots
[] spawn {
    while {true} do {
        {
            if (!isPlayer _x && alive _x && _x distance player < 1000) then {
                
                // Add Hit event handler to nearby AI
                if (isNil {_x getVariable "ExileLS_HasHitHandler"}) then {
                    
                    _x addEventHandler ["Hit", {
                        params ["_unit", "_source", "_damage", "_instigator"];
                        
                        if (_source == player || _instigator == player) then {
                            
                            // Get hit part
                            private _hitPart = _unit getHit "head";
                            
                            if (_hitPart > 0) then {
                                _unit setVariable ["exile_lastHitPart", "head", true];
                                _unit setVariable ["ExileIsHeadshot", true, true];
                                
                                diag_log format["[LevelSystem] Headshot registered: %1", typeOf _unit];
                            };
                        };
                    }];
                    
                    _x setVariable ["ExileLS_HasHitHandler", true];
                };
            };
        } forEach allUnits;
        
        uiSleep 5;
    };
};

true