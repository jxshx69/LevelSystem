/*
    ExileClient_LevelSystem_gui_xm8_show
    
    Zeigt das Level System Admin Panel in der XM8
*/

private ["_display", "_leftPane", "_rightPane"];

disableSerialization;

_display = uiNameSpace getVariable ["RscExileXM8", displayNull];

if (isNull _display) exitWith 
{
    ["ErrorTitleAndText", ["XM8 Error", "XM8 Display not found"]] call ExileClient_gui_toaster_addTemplateToast;
};

// Linke Seite - Info
_leftPane = _display ctrlCreate ["RscStructuredText", 4100];
_leftPane ctrlSetPosition [
    0.015 * safezoneW + safezoneX,
    0.25 * safezoneH + safezoneY,
    0.45 * safezoneW,
    0.5 * safezoneH
];
_leftPane ctrlCommit 0;

// Level Info Text
_level = call ExileClient_LevelSystem_getLevel;
_xp = ExileClientPlayerXP;
_nextLevelXP = if (_level < (count ExileClientLevelSystemXPTable)) then {
    ExileClientLevelSystemXPTable select _level
} else {
    "MAX"
};

_discount = call ExileClient_LevelSystem_getTraderDiscount;
_speed = call ExileClient_LevelSystem_getSpeedBoost;
_heal = call ExileClient_LevelSystem_getHealBoost;
_locker = call ExileClient_LevelSystem_getLockerLimit;
_container = call ExileClient_LevelSystem_getContainerLimit;

_infoText = format[
    "<t align='center' size='1.5' color='#FFD700'>LEVEL %1</t><br/><br/>" +
    "<t size='1.1' color='#FFFFFF'>XP: %2 / %3</t><br/><br/>" +
    "<t size='1.2' color='#00FF00'>═══ DEINE BONI ═══</t><br/>" +
    "<t color='#AAAAAA'>Trader Rabatt:</t> <t color='#00FF00'>%4%10</t><br/>" +
    "<t color='#AAAAAA'>Speed Boost:</t> <t color='#00FF00'>x%5</t><br/>" +
    "<t color='#AAAAAA'>Heal Boost:</t> <t color='#00FF00'>x%6</t><br/>" +
    "<t color='#AAAAAA'>Locker Limit:</t> <t color='#FFD700'>%7 Poptabs</t><br/>" +
    "<t color='#AAAAAA'>Container Limit:</t> <t color='#FFD700'>%8 Poptabs</t><br/><br/>" +
    "<t size='0.9' color='#888888'>Du verdienst XP durch Spielen, Kills, Missionen und mehr!</t>",
    _level, _xp, _nextLevelXP, _discount, _speed, _heal, _locker, _container, "%", "%"
];

_leftPane ctrlSetStructuredText parseText _infoText;

// Rechte Seite - Admin Buttons (nur für Admins)
if ((getPlayerUID player) in ["76561198152919170"]) then 
{
    _rightPane = _display ctrlCreate ["RscControlsGroup", 4101];
    _rightPane ctrlSetPosition [
        0.485 * safezoneW + safezoneX,
        0.25 * safezoneH + safezoneY,
        0.45 * safezoneW,
        0.5 * safezoneH
    ];
    _rightPane ctrlCommit 0;
    
    // Admin Title
    _adminTitle = _display ctrlCreate ["RscStructuredText", 4102, _rightPane];
    _adminTitle ctrlSetPosition [0, 0, 0.45 * safezoneW, 0.05 * safezoneH];
    _adminTitle ctrlSetStructuredText parseText "<t align='center' size='1.3' color='#FF0000'>ADMIN TOOLS</t>";
    _adminTitle ctrlCommit 0;
    
    // Button: Set Level
    _btnSetLevel = _display ctrlCreate ["RscButtonMenu", 4103, _rightPane];
    _btnSetLevel ctrlSetPosition [0.05 * safezoneW, 0.06 * safezoneH, 0.35 * safezoneW, 0.05 * safezoneH];
    _btnSetLevel ctrlSetText "Set Level";
    _btnSetLevel ctrlCommit 0;
    _btnSetLevel ctrlAddEventHandler ["ButtonClick", {
        _level = parseNumber (["Enter Level (1-20)", ""] call ExileClient_gui_input_show);
        if (_level >= 1 && _level <= 20) then {
            [_level] call ExileLS_SetLevel;
        } else {
            ["ErrorTitleAndText", ["Error", "Level must be between 1-20"]] call ExileClient_gui_toaster_addTemplateToast;
        };
    }];
    
    // Button: Add XP
    _btnAddXP = _display ctrlCreate ["RscButtonMenu", 4104, _rightPane];
    _btnAddXP ctrlSetPosition [0.05 * safezoneW, 0.12 * safezoneH, 0.35 * safezoneW, 0.05 * safezoneH];
    _btnAddXP ctrlSetText "Add XP";
    _btnAddXP ctrlCommit 0;
    _btnAddXP ctrlAddEventHandler ["ButtonClick", {
        _xp = parseNumber (["Enter XP Amount", ""] call ExileClient_gui_input_show);
        if (_xp > 0) then {
            [_xp] call ExileLS_AddXP;
        } else {
            ["ErrorTitleAndText", ["Error", "XP must be positive"]] call ExileClient_gui_toaster_addTemplateToast;
        };
    }];
    
    // Button: Reset Level
    _btnReset = _display ctrlCreate ["RscButtonMenu", 4105, _rightPane];
    _btnReset ctrlSetPosition [0.05 * safezoneW, 0.18 * safezoneH, 0.35 * safezoneW, 0.05 * safezoneH];
    _btnReset ctrlSetText "Reset Level";
    _btnReset ctrlCommit 0;
    _btnReset ctrlAddEventHandler ["ButtonClick", {
        call ExileLS_ResetLevel;
    }];
    
    // Button: Show Debug Info
    _btnDebug = _display ctrlCreate ["RscButtonMenu", 4106, _rightPane];
    _btnDebug ctrlSetPosition [0.05 * safezoneW, 0.24 * safezoneH, 0.35 * safezoneW, 0.05 * safezoneH];
    _btnDebug ctrlSetText "Debug Info";
    _btnDebug ctrlCommit 0;
    _btnDebug ctrlAddEventHandler ["ButtonClick", {
        call ExileLS_Debug_ShowInfo;
    }];
}
else 
{
    // Für normale Spieler: Nur Info
    _rightPane = _display ctrlCreate ["RscStructuredText", 4107];
    _rightPane ctrlSetPosition [
        0.485 * safezoneW + safezoneX,
        0.35 * safezoneH + safezoneY,
        0.45 * safezoneW,
        0.1 * safezoneH
    ];
    _rightPane ctrlSetStructuredText parseText "<t align='center' size='1.1' color='#888888'>Weiter leveln und mehr Boni freischalten!</t>";
    _rightPane ctrlCommit 0;
};

true