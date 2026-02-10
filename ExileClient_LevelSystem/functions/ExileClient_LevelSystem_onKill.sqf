/*
    Handle Kill Events for Level System
    
    _this select 0: OBJECT - Killed unit
    _this select 1: OBJECT - Killer (player)
*/

private ["_killed", "_killer", "_xpAmount", "_isHeadshot", "_bonusXP", "_killedType", "_distance"];

_killed = _this select 0;
_killer = _this select 1;

// Verify killer is player
if (_killer != player) exitWith {false};
if (!alive player) exitWith {false};
if (isNull _killed) exitWith {false};

_killedType = typeOf _killed;

diag_log format["[LevelSystem] Kill detected: %1 (Type: %2)", name _killed, _killedType];

_xpAmount = 0;
_bonusXP = 0;

// ========================================
// ZOMBIE KILL CHECK (Priority!)
// ========================================
if (_killedType find "RyanZombie" != -1 || _killedType find "zombie" != -1 || _killed getVariable ["ExileZ", false]) exitWith 
{
    diag_log "[LevelSystem] Detected as ZOMBIE - calling zombie handler";
    [_killed, _killer] call ExileClient_LevelSystem_onZombieKill;
    
    true  // Exit - don't give AI XP for zombies
};

// ========================================
// PLAYER KILL
// ========================================
if (isPlayer _killed) then 
{
    _xpAmount = [ExileClientLevelSystemXPRewards, "PlayerKill"] call BIS_fnc_getFromPairs;
    
    diag_log format["[LevelSystem] Player kill: %1 - %2 XP", name _killed, _xpAmount];
    
    // Distance bonus for long range kills
    _distance = player distance _killed;
    if (_distance > 300) then 
    {
        _bonusXP = _bonusXP + 50;
        diag_log format["[LevelSystem] Long range kill bonus: 50 XP (Distance: %1m)", round _distance];
    };
}
// ========================================
// AI KILL
// ========================================
else 
{
    if (_killed isKindOf "Man") then 
    {
        _xpAmount = [ExileClientLevelSystemXPRewards, "AIKill"] call BIS_fnc_getFromPairs;
        
        diag_log format["[LevelSystem] AI kill: %1 - %2 XP", _killedType, _xpAmount];
        
        // Check for headshot
        _isHeadshot = _killed getVariable ["ExileIsHeadshot", false];
        
        // Alternative headshot detection (check last hit part)
        if (!_isHeadshot) then 
        {
            private _hitPart = _killed getVariable ["exile_lastHitPart", ""];
            if (_hitPart in ["head", "face", "neck"]) then 
            {
                _isHeadshot = true;
            };
        };
        
        // Headshot bonus
        if (_isHeadshot) then 
        {
            _bonusXP = [ExileClientLevelSystemXPRewards, "Headshot"] call BIS_fnc_getFromPairs;
            diag_log format["[LevelSystem] HEADSHOT! Bonus: %1 XP", _bonusXP];
        };
    }
    // ========================================
    // VEHICLE KILL
    // ========================================
    else 
    {
        if (_killed isKindOf "LandVehicle" || _killed isKindOf "Air" || _killed isKindOf "Ship") then 
        {
            _xpAmount = [ExileClientLevelSystemXPRewards, "VehicleKill"] call BIS_fnc_getFromPairs;
            
            diag_log format["[LevelSystem] Vehicle kill: %1 - %2 XP", _killedType, _xpAmount];
            
            // Bonus for air vehicles
            if (_killed isKindOf "Air") then 
            {
                _bonusXP = _bonusXP + 50;
                diag_log "[LevelSystem] Air vehicle bonus: 50 XP";
            };
        };
    };
};

// ========================================
// AWARD XP
// ========================================
_xpAmount = _xpAmount + _bonusXP;

if (_xpAmount > 0) then 
{
    [_xpAmount, "Kill"] call ExileClient_LevelSystem_addXP;
    
    if (ExileClientLevelSystemShowNotifications) then 
    {
        private _killText = "Kill";
        if (isPlayer _killed) then { _killText = "Player Kill"; };
        if (_isHeadshot) then { _killText = _killText + " (Headshot)"; };
        
        ["SuccessTitleAndText", ["XP Gewonnen!", format["+%1 XP (%2)", _xpAmount, _killText]]] call ExileClient_gui_toaster_addTemplateToast;
    };
    
    diag_log format["[LevelSystem] Total XP awarded: %1", _xpAmount];
};

true