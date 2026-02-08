/*
    Level System Admin Dialog
*/

closeDialog 0;

createDialog "RscDisplayXM8";

waitUntil { !isNull (findDisplay 12000) };

private _display = findDisplay 12000;

// Admin Panel anzeigen
hint parseText format[
    "<t align='center' size='1.3' color='#FFD700'>LEVEL SYSTEM ADMIN</t><br/><br/>" +
    "<t align='left' size='0.9' color='#FFFFFF'>" +
    "Current Level: <t color='#00FF00'>%1</t><br/>" +
    "Current XP: <t color='#00FF00'>%2</t><br/><br/>" +
    "<t color='#FFD700'>Available Commands:</t><br/>" +
    "• Set Level: [LEVEL] call ExileLS_SetLevel;<br/>" +
    "• Add XP: [AMOUNT] call ExileLS_AddXP;<br/>" +
    "• Reset: call ExileLS_ResetLevel;<br/>" +
    "• Show Bonuses: call ExileLS_ShowBonuses;<br/>" +
    "</t>",
    ExileClientPlayerLevel,
    ExileClientPlayerXP
];