/*
    XM8 App for Level System
    Shows detailed level info and stats
*/

private ["_display", "_level", "_currentXP", "_nextLevelXP", "_progress", "_discount", "_speed", "_heal", "_locker", "_container"];

disableSerialization;
_display = uiNameSpace getVariable ["RscExileXM8", displayNull];

// Get current stats
_level = call ExileClient_LevelSystem_getLevel;
_currentXP = ExileClientPlayerXP;
_nextLevelXP = if (_level < (count ExileClientLevelSystemXPTable)) then {
    ExileClientLevelSystemXPTable select _level
} else {
    _currentXP
};

_progress = if (_nextLevelXP > 0) then {
    floor((_currentXP / _nextLevelXP) * 100)
} else {
    100
};

// Get bonuses with empty array parameter
_discount = [] call ExileClient_LevelSystem_getTraderDiscount;
_speed = [] call ExileClient_LevelSystem_getSpeedBoost;
_heal = [] call ExileClient_LevelSystem_getHealBoost;
_locker = [] call ExileClient_LevelSystem_getLockerLimit;
_container = [] call ExileClient_LevelSystem_getContainerLimit;

diag_log format["[LevelSystem XM8] Displaying stats - Level: %1, XP: %2/%3, Discount: %4%8, Speed: x%5, Heal: x%6, Locker: %7", _level, _currentXP, _nextLevelXP, _discount, _speed, _heal, _locker, "%"];

// Hide XM8 Apps controls
{
    (_display displayCtrl _x) ctrlSetFade 1;
    (_display displayCtrl _x) ctrlCommit 0.25;
} forEach [991,881,992,882,993,883,994,884,995,885,996,886,997,887,998,888,999,889,9910,8810,9911,8811,9912,8812];

uiSleep 0.25;

// Create main frame
_mainFrame = _display ctrlCreate ["RscExileXM8Frame", 8000];
_mainFrame ctrlSetPosition [(8 - 3) * (0.025) + (0), (7 - 2) * (0.04) + (0), 28 * (0.025), 14 * (0.04)];
_mainFrame ctrlCommit 0;

// Title
_titleText = _display ctrlCreate ["RscText", 8001];
_titleText ctrlSetPosition [(9 - 3) * (0.025) + (0), (7.5 - 2) * (0.04) + (0), 26 * (0.025), 1 * (0.04)];
_titleText ctrlSetText format["LEVEL SYSTEM - Level %1", _level];
_titleText ctrlSetTextColor [1, 0.843, 0, 1]; // Gold
_titleText ctrlSetFont "PuristaLight";
_titleText ctrlSetFontHeight 0.04;
_titleText ctrlCommit 0;

// XP Progress
_xpText = _display ctrlCreate ["RscStructuredText", 8002];
_xpText ctrlSetPosition [(9 - 3) * (0.025) + (0), (9 - 2) * (0.04) + (0), 26 * (0.025), 1.5 * (0.04)];
if (_level >= (count ExileClientLevelSystemXPTable)) then {
    _xpText ctrlSetStructuredText parseText format["<t size='0.8' align='center' color='#00FF00'>MAX LEVEL REACHED!</t>"];
} else {
    _xpText ctrlSetStructuredText parseText format["<t size='0.8' align='center'>XP: %1 / %2 (%3%4)</t>", _currentXP, _nextLevelXP, _progress, "%"];
};
_xpText ctrlCommit 0;

// Bonuses Frame
_bonusFrame = _display ctrlCreate ["RscExileXM8Frame", 8003];
_bonusFrame ctrlSetPosition [(9 - 3) * (0.025) + (0), (11 - 2) * (0.04) + (0), 26 * (0.025), 8 * (0.04)];
_bonusFrame ctrlCommit 0;

// Bonuses Title
_bonusTitle = _display ctrlCreate ["RscText", 8004];
_bonusTitle ctrlSetPosition [(10 - 3) * (0.025) + (0), (11.5 - 2) * (0.04) + (0), 24 * (0.025), 1 * (0.04)];
_bonusTitle ctrlSetText "YOUR CURRENT BONUSES:";
_bonusTitle ctrlSetTextColor [0, 0.7, 1, 1];
_bonusTitle ctrlSetFont "PuristaLight";
_bonusTitle ctrlCommit 0;

// Bonus List
_bonusText = _display ctrlCreate ["RscStructuredText", 8005];
_bonusText ctrlSetPosition [(10 - 3) * (0.025) + (0), (13 - 2) * (0.04) + (0), 24 * (0.025), 5.5 * (0.04)];
_bonusText ctrlSetStructuredText parseText format[
    "<t size='0.7'>" +
    "• Trader Discount: <t color='#00FF00'>%1%6</t><br/>" +
    "• Speed Boost: <t color='#00FF00'>x%2</t><br/>" +
    "• Heal Boost: <t color='#00FF00'>x%3</t><br/>" +
    "• Locker Limit: <t color='#FFD700'>%4 Poptabs</t><br/>" +
    "• Container Limit: <t color='#FFD700'>%5 Poptabs</t>" +
    "</t>",
    _discount,
    _speed,
    _heal,
    _locker,
    _container,
    "%"
];
_bonusText ctrlCommit 0;

// Go Back Button
_goBackButton = _display ctrlCreate ["RscButtonMenu", 8999];
_goBackButton ctrlSetPosition [(31 - 3) * (0.025) + (0), (20 - 2) * (0.04) + (0), 4.5 * (0.025), 1 * (0.04)];
_goBackButton ctrlSetText "GO BACK";
_goBackButton ctrlSetEventHandler ["ButtonClick", {
    {ctrlDelete ((_this select 0) displayCtrl _x)} forEach [8000,8001,8002,8003,8004,8005,8999];
    [] execVM "xm8Apps\XM8Apps_Init.sqf";
}];
_goBackButton ctrlCommit 0;