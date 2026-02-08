/*
    Check if player leveled up
*/

private ["_currentLevel", "_maxLevel", "_requiredXP", "_leveledUp"];

_currentLevel = ExileClientPlayerLevel;
_maxLevel = count ExileClientLevelSystemXPTable;
_leveledUp = false;

// Check if player can level up
while {_currentLevel < _maxLevel} do {
    _requiredXP = ExileClientLevelSystemXPTable select _currentLevel;
    
    if (ExileClientPlayerXP >= _requiredXP) then {
        _currentLevel = _currentLevel + 1;
        _leveledUp = true;
    } else {
        break;
    };
};

// Update level if changed
if (_leveledUp) then {
    ExileClientPlayerLevel = _currentLevel;
    
    // Show level up notification
    if (ExileClientLevelSystemShowLevelUp) then {
        ["Success", [format["LEVEL UP! You are now Level %1", _currentLevel]]] call ExileClient_gui_toaster_addTemplateToast;
        playSound "FD_Finish_F";
    };
    
	// Update HUD
	if (ExileClientLevelSystemShowHUD) then {
		call ExileClient_LevelSystem_displayLevel;  // ✅ OK
	};
};

_leveledUp