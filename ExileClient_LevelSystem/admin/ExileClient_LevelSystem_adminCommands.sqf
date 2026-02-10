/*
    XM8 Admin App for Level System
*/

private ["_display", "_mainFrame", "_title"];

disableSerialization;
_display = uiNameSpace getVariable ["RscExileXM8", displayNull];

// Check admin (modify as needed)
if (!isServer && !(serverCommandAvailable "#kick")) exitWith {
    ["ErrorTitleAndText", ["Access Denied!", "You are not an administrator."]] call ExileClient_gui_toaster_addTemplateToast;
};

// Hide XM8 Apps controls
{
    (_display displayCtrl _x) ctrlSetFade 1;
    (_display displayCtrl _x) ctrlCommit 0.25;
} forEach [991,881,992,882,993,883,994,884,995,885,996,886,997,887,998,888,999,889,9910,8810,9911,8811,9912,8812];

uiSleep 0.25;

// Create main frame
_mainFrame = _display ctrlCreate ["RscExileXM8Frame", 9000];
_mainFrame ctrlSetPosition [(8 - 3) * (0.025) + (0), (7 - 2) * (0.04) + (0), 28 * (0.025), 14 * (0.04)];
_mainFrame ctrlCommit 0;

// Title
_title = _display ctrlCreate ["RscText", 9001];
_title ctrlSetPosition [(9 - 3) * (0.025) + (0), (7.5 - 2) * (0.04) + (0), 26 * (0.025), 1 * (0.04)];
_title ctrlSetText "LEVEL SYSTEM - ADMIN PANEL";
_title ctrlSetTextColor [1, 0, 0, 1]; // Red
_title ctrlSetFont "PuristaLight";
_title ctrlSetFontHeight 0.04;
_title ctrlCommit 0;

// Buttons
private _buttonY = 9;
private _buttons = [
    ["Set Level 5", {[5] call ExileLS_SetLevel}],
    ["Set Level 10", {[10] call ExileLS_SetLevel}],
    ["Set Level 20", {[20] call ExileLS_SetLevel}],
    ["Add 1000 XP", {[1000] call ExileLS_AddXP}],
    ["Add 5000 XP", {[5000] call ExileLS_AddXP}],
    ["Reset Level", {call ExileLS_ResetLevel}],
    ["Show Bonuses", {call ExileLS_ShowBonuses}]
];

{
    private _btn = _display ctrlCreate ["RscButtonMenu", 9100 + _forEachIndex];
    _btn ctrlSetPosition [(10 - 3) * (0.025) + (0), (_buttonY - 2) * (0.04) + (0), 12 * (0.025), 1 * (0.04)];
    _btn ctrlSetText (_x select 0);
    _btn ctrlSetEventHandler ["ButtonClick", format["call %1", _x select 1]];
    _btn ctrlCommit 0;
    
    _buttonY = _buttonY + 1.5;
} forEach _buttons;

// Go Back Button
_goBackButton = _display ctrlCreate ["RscButtonMenu", 9999];
_goBackButton ctrlSetPosition [(31 - 3) * (0.025) + (0), (20 - 2) * (0.04) + (0), 4.5 * (0.025), 1 * (0.04)];
_goBackButton ctrlSetText "GO BACK";
_goBackButton ctrlSetEventHandler ["ButtonClick", {
    for "_i" from 9000 to 9999 do {
        ctrlDelete ((_this select 0) displayCtrl _i);
    };
    [] execVM "xm8Apps\XM8Apps_Init.sqf";
}];
_goBackButton ctrlCommit 0;