/*
    Receive zombie kill XP from server
    
    _this select 0: SCALAR - XP Amount
    _this select 1: STRING - Zombie Name
*/

private ["_xpAmount", "_zombieName"];

_xpAmount = _this select 0;
_zombieName = _this select 1;

// Award XP
[_xpAmount, format["Zombie (%1)", _zombieName]] call ExileClient_LevelSystem_addXP;

diag_log format["[LevelSystem] Zombie kill XP received: %1 XP for %2", _xpAmount, _zombieName];

// Streak tracking
if (isNil "ExileLS_ZombieKillStreak") then { ExileLS_ZombieKillStreak = []; };
ExileLS_ZombieKillStreak pushBack time;
ExileLS_ZombieKillStreak = ExileLS_ZombieKillStreak select {(time - _x) < 120};

private _streakCount = count ExileLS_ZombieKillStreak;

// Every 10 zombies in 2 minutes = streak bonus
if (_streakCount > 0 && (_streakCount % 10) == 0) then {
    [100, "Zombie Streak"] call ExileClient_LevelSystem_addXP;
    ["SuccessTitleAndText", ["ZOMBIE MASSACRE!", format["+100 XP Streak Bonus (%1 kills)", _streakCount]]] call ExileClient_gui_toaster_addTemplateToast;
    
    diag_log format["[LevelSystem] Zombie streak bonus: 100 XP (%1 kills)", _streakCount];
};

// Every 50 zombies = mega bonus
if (_streakCount > 0 && (_streakCount % 50) == 0) then {
    [500, "Zombie Slayer"] call ExileClient_LevelSystem_addXP;
    ["SuccessTitleAndText", ["🧟 ZOMBIE SLAYER! 🧟", format["+500 XP MEGA BONUS! (%1 kills)", _streakCount]]] call ExileClient_gui_toaster_addTemplateToast;
    
    diag_log format["[LevelSystem] Zombie MEGA streak bonus: 500 XP (%1 kills)", _streakCount];
};

true