/*
    Handle Respawn - XP Penalty
*/

private ["_currentXP", "_penalty", "_newXP"];

_currentXP = player getVariable ["ExileXP", 0];
_penalty = round (_currentXP * 0.1); // 10% XP Verlust

if (_penalty > 0) then 
{
    _newXP = _currentXP - _penalty;
    if (_newXP < 0) then { _newXP = 0; };
    
    player setVariable ["ExileXP", _newXP];
    ExileClientPlayerXP = _newXP;
    
    // Save to server
    ["saveLevelRequest", [player getVariable ["ExileLevel", 1], _newXP]] call ExileClient_system_network_send;
    
    diag_log format["[LevelSystem] Respawn penalty: -%1 XP (10%%)", _penalty];
    
    ["ErrorTitleAndText", ["Tod!", format["Du hast %1 XP verloren!", _penalty]]] call ExileClient_gui_toaster_addTemplateToast;
};

true