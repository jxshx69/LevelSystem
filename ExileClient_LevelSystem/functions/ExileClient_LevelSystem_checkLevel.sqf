/*
    Check if player should level up or level down
    Reads from PLAYER OBJECT
*/

private ["_currentLevel", "_currentXP", "_nextLevelXP", "_leveledUp"];

_leveledUp = false;

// ========================================
// GET FROM PLAYER OBJECT (NOT GLOBAL!)
// ========================================
_currentLevel = player getVariable ["ExileLevel", 1];
_currentXP = player getVariable ["ExileXP", 0];

// Max level check
if (_currentLevel >= (count ExileClientLevelSystemXPTable)) exitWith {
    diag_log "[LevelSystem] Max level reached";
    
    // Update HUD anyway
    call ExileClient_LevelSystem_displayLevel;
    
    false
};

// Get XP required for next level
_nextLevelXP = ExileClientLevelSystemXPTable select _currentLevel;

diag_log format["[LevelSystem] Level Check for %1", name player];
diag_log format["  Current: Level %1, XP %2", _currentLevel, _currentXP];
diag_log format["  Required for next: %1 XP", _nextLevelXP];

// ========================================
// CHECK FOR LEVEL UP (can level up multiple times)
// ========================================
while {_currentXP >= _nextLevelXP && _currentLevel < (count ExileClientLevelSystemXPTable)} do {
    _currentLevel = _currentLevel + 1;
    _leveledUp = true;
    
    // Update PLAYER OBJECT
    player setVariable ["ExileLevel", _currentLevel, false];
    
    // Also update global
    ExileClientPlayerLevel = _currentLevel;
    
    diag_log format["[LevelSystem] 🎉 LEVEL UP! %1 reached Level %2", name player, _currentLevel];
    
    // Show level up effect
    [_currentLevel] call ExileClient_LevelSystem_showLevelUp;
    
    // Play sound
    playSound "LevelUp";
    
    // Check next level
    if (_currentLevel < (count ExileClientLevelSystemXPTable)) then {
        _nextLevelXP = ExileClientLevelSystemXPTable select _currentLevel;
    };
};

// ========================================
// CHECK FOR LEVEL DOWN (if XP drops below current level)
// ========================================
if (_currentLevel > 1) then {
    private _currentLevelMinXP = ExileClientLevelSystemXPTable select (_currentLevel - 1);
    
    while {_currentXP < _currentLevelMinXP && _currentLevel > 1} do {
        _currentLevel = _currentLevel - 1;
        
        // Update PLAYER OBJECT
        player setVariable ["ExileLevel", _currentLevel, false];
        
        // Also update global
        ExileClientPlayerLevel = _currentLevel;
        
        diag_log format["[LevelSystem] ⬇️ LEVEL DOWN! %1 dropped to Level %2", name player, _currentLevel];
        
        // Show notification
        ["ErrorTitleAndText", ["Level Down!", format["You dropped to Level %1", _currentLevel]]] call ExileClient_gui_toaster_addTemplateToast;
        
        // Check next level down
        if (_currentLevel > 1) then {
            _currentLevelMinXP = ExileClientLevelSystemXPTable select (_currentLevel - 1);
        };
    };
};

// Update HUD
call ExileClient_LevelSystem_displayLevel;

_leveledUp