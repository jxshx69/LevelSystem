/*
    Add XP to player
    
    _this select 0: STRING - Action type
    _this select 1: NUMBER (OPTIONAL) - Custom XP amount
*/

private ["_actionType", "_xpAmount", "_customXP"];

_actionType = _this select 0;
_customXP = if (count _this > 1) then {_this select 1} else {-1};

// Get XP amount from config
_xpAmount = 0;
{
    if ((_x select 0) isEqualTo _actionType) exitWith {
        _xpAmount = _x select 1;
    };
} forEach ExileClientLevelSystemXPRewards;

// Use custom XP if provided
if (_customXP > 0) then {
    _xpAmount = _customXP;
};

// Add XP
ExileClientPlayerXP = ExileClientPlayerXP + _xpAmount;

// Show notification
if (ExileClientLevelSystemShowNotifications) then {
    ["Success", [format["+%1 XP (%2)", _xpAmount, _actionType]]] call ExileClient_gui_toaster_addTemplateToast;
};

// Check for level up
call ExileClient_LevelSystem_checkLevel;

// Save to server - FIXED FORMAT
["saveLevelRequest", [ExileClientPlayerLevel, ExileClientPlayerXP]] call ExileClient_system_network_send;

diag_log format["[LevelSystem] Added %1 XP (%2) - Total: %3", _xpAmount, _actionType, ExileClientPlayerXP];

true