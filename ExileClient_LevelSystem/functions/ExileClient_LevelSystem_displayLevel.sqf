/*
    Display player level and XP on HUD
    IMPROVED: Smaller, better positioned, transparent background
*/

private ["_display", "_level", "_currentXP", "_nextLevelXP", "_progress", "_text", "_levelHUD", "_idc", "_prevLevelXP"];

// Get display
_display = findDisplay 46;
if (isNull _display) exitWith {
    diag_log "[LevelSystem] Display 46 not found, cannot create HUD";
    false
};

// Use fixed IDC
_idc = 9876;

// Remove old control if exists
if (!isNull (_display displayCtrl _idc)) then {
    ctrlDelete (_display displayCtrl _idc);
};

// Get current stats
_level = ExileClientPlayerLevel;
_currentXP = ExileClientPlayerXP;
_nextLevelXP = 0;

// Get XP required for next level
if (_level < (count ExileClientLevelSystemXPTable)) then {
    _nextLevelXP = ExileClientLevelSystemXPTable select _level;
} else {
    _nextLevelXP = _currentXP; // Max level reached
};

// Calculate progress percentage (XP within current level)
_progress = 0;
if (_nextLevelXP > 0) then {
    if (_level < (count ExileClientLevelSystemXPTable)) then {
        _prevLevelXP = 0;
        if (_level > 1) then {
            _prevLevelXP = ExileClientLevelSystemXPTable select (_level - 1);
        };
        _progress = ((_currentXP - _prevLevelXP) / (_nextLevelXP - _prevLevelXP)) * 100;
    } else {
        _progress = 100;
    };
    if (_progress > 100) then {_progress = 100};
    if (_progress < 0) then {_progress = 0};
};

// ========================================
// CREATE HUD TEXT - COMPACT & CLEAN
// ========================================
if (_level >= (count ExileClientLevelSystemXPTable)) then {
    _text = format[
        "<t size='0.7' font='PuristaBold' color='#FFD700' shadow='2' align='left'>" +
        "★ LEVEL %1 (MAX) ★" +
        "</t>", 
        _level
    ];
} else {
    _text = format[
        "<t size='0.65' font='PuristaBold' shadow='2' align='left'>" +
        "<t color='#FFD700'>LVL %1</t> " +
        "<t size='0.55' color='#FFFFFF'>| %2%3</t>" +
        "</t>", 
        _level,
        round(_progress),
        "%"
    ];
};

// ========================================
// CREATE HUD CONTROL - CLEAN POSITIONING
// ========================================
_levelHUD = _display ctrlCreate ["RscStructuredText", _idc];

// Position: TOP LEFT (compact, single line)
_levelHUD ctrlSetPosition [
    safeZoneX + 0.01,           // Left margin (very close to edge)
    safeZoneY + 0.04,           // Top (just below compass)
    0.15,                       // Width (compact)
    0.03                        // Height (single line)
];

// Set text and background - TRANSPARENT!
_levelHUD ctrlSetStructuredText parseText _text;
_levelHUD ctrlSetBackgroundColor [0, 0, 0, 0.3];  // Semi-transparent instead of solid black
_levelHUD ctrlCommit 0;

true