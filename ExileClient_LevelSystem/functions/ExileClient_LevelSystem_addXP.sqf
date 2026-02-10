/*
    Add XP to player
    
    _this select 0: STRING/NUMBER - Action type OR custom XP amount
    _this select 1: NUMBER/STRING (OPTIONAL) - Custom XP amount OR source description
*/

private ["_actionType", "_xpAmount", "_customXP", "_firstParam", "_source", "_currentLevel", "_currentXP", "_newXP"];

_firstParam = _this select 0;
_xpAmount = 0;
_source = "Unknown";

// Check if first parameter is a number (direct XP) or string (action type)
if (typeName _firstParam == "SCALAR") then 
{
    // Direct XP amount
    _xpAmount = _firstParam;
    _source = if (count _this > 1) then {_this select 1} else {"Custom"};
    _actionType = _source;
}
else 
{
    // Action type (string)
    _actionType = _firstParam;
    _source = _actionType;
    
    // Get XP amount from config
    {
        if ((_x select 0) isEqualTo _actionType) exitWith {
            _xpAmount = _x select 1;
        };
    } forEach ExileClientLevelSystemXPRewards;
    
    // Use custom XP if provided as second parameter
    if (count _this > 1) then {
        _customXP = _this select 1;
        if (typeName _customXP == "SCALAR" && _customXP > 0) then {
            _xpAmount = _customXP;
        };
    };
};

// Validate XP amount
if (isNil "_xpAmount" || typeName _xpAmount != "SCALAR") then {
    _xpAmount = 0;
};

if (_xpAmount <= 0) exitWith {
    diag_log format["[LevelSystem] WARNING: Invalid XP amount for action '%1'", _actionType];
    false
};

// ========================================
// GET CURRENT VALUES FROM PLAYER OBJECT
// ========================================
_currentLevel = player getVariable ["ExileLevel", 1];
_currentXP = player getVariable ["ExileXP", 0];

diag_log format["[LevelSystem] addXP called for %1", name player];
diag_log format["  Amount: +%1 XP", _xpAmount];
diag_log format["  Source: %1", _source];
diag_log format["  Before: Level %1, XP %2", _currentLevel, _currentXP];

// Add XP
_newXP = _currentXP + _xpAmount;

// ========================================
// UPDATE PLAYER OBJECT (SOURCE OF TRUTH!)
// ========================================
player setVariable ["ExileXP", _newXP, false];

// Also update global for compatibility
ExileClientPlayerXP = _newXP;

diag_log format["  After: XP %1", _newXP];

// Show notification
if (ExileClientLevelSystemShowNotifications) then {
    ["SuccessTitleAndText", ["XP Gewonnen!", format["+%1 XP (%2)", _xpAmount, _actionType]]] call ExileClient_gui_toaster_addTemplateToast;
};

// ========================================
// CHECK FOR LEVEL UP
// ========================================
call ExileClient_LevelSystem_checkLevel;

// Save to server
_currentLevel = player getVariable ["ExileLevel", 1];  // Get updated level after checkLevel
["saveLevelRequest", [_currentLevel, _newXP]] call ExileClient_system_network_send;

diag_log format["[LevelSystem] Save request sent: Level %1, XP %2", _currentLevel, _newXP];

true