/**
 * ExileClient_gui_lockerDialog_show
 * MODIFIED: Dynamic locker limit based on level + Fixed money display
 */
 
private["_dialog","_lockerAmount","_lockerLimit","_depositInput","_withdrawInput","_lockerAmountLabel","_inventoryAmount","_inventoryAmountString","_inventoryAmountLabel","_playerLevel"];
disableSerialization;

// Force refresh player money
player setVariable ["ExileMoney", player getVariable ["ExileMoney", 0], true];

createDialog "RscExileLockerDialog";
_dialog = uiNameSpace getVariable ["RscExileLockerDialog", displayNull];

_lockerAmount = player getVariable ["ExileLocker", 0];

diag_log format["[LevelSystem] Locker Dialog - Locker Amount: %1", _lockerAmount];

// ========================================
// LEVEL SYSTEM: Dynamic Locker Limit
// ========================================
_playerLevel = player getVariable ["ExileLevel", 1];
_lockerLimit = call ExileClient_LevelSystem_getLockerLimit;

// Fallback to config if function fails
if (isNil "_lockerLimit" || _lockerLimit == 0) then {
    _lockerLimit = getNumber(missionConfigFile >> "CfgLocker" >> "maxDeposit");
};

diag_log format["[LevelSystem] Locker Dialog - Level: %1, Limit: %2", _playerLevel, _lockerLimit];
// ========================================

_depositInput = _dialog displayCtrl 4006;
_depositInput ctrlSetText "";
_withdrawInput = _dialog displayCtrl 4005;
_withdrawInput ctrlSetText "";

_lockerAmountLabel = _dialog displayCtrl 4000;
_lockerAmountLabel ctrlSetStructuredText (parseText format["<t size='1.4'>%1 / %2 <img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='1' shadow='true' /></t>", _lockerAmount, _lockerLimit]);

// Get inventory money (multiple fallbacks)
_inventoryAmount = player getVariable ["ExileMoney", 0];

// Fallback 1: Try global variable
if (_inventoryAmount == 0) then {
    _inventoryAmount = ExileClientPlayerMoney;
};

// Fallback 2: Force update from server
if (isNil "_inventoryAmount" || _inventoryAmount == 0) then {
    _inventoryAmount = 0;
    diag_log "[LevelSystem] WARNING: Player money is 0 or nil!";
};

diag_log format["[LevelSystem] Locker Dialog - Player Money: %1", _inventoryAmount];

_inventoryAmountString = _inventoryAmount call ExileClient_util_string_exponentToString;
_inventoryAmountLabel = _dialog displayCtrl 4001;
_inventoryAmountLabel ctrlSetStructuredText (parseText format["<t size='1.4'>%1 <img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='1' shadow='true' /></t>", _inventoryAmountString]);

true call ExileClient_gui_postProcessing_toggleDialogBackgroundBlur;

diag_log format["[LevelSystem] Locker Dialog opened - Balance: %1, Inventory: %2, Limit: %3", _lockerAmount, _inventoryAmount, _lockerLimit];

true