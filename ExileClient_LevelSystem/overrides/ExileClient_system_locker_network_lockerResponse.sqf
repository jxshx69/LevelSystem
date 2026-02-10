/**
 * ExileClient_system_locker_network_lockerResponse
 * MODIFIED: Dynamic locker limit based on level + Fixed money display
 */
 
private["_dialog","_lockerAmount","_lockerLimit","_depositInput","_withdrawInput","_lockerAmountLabel","_inventoryAmount","_inventoryAmountLabel","_playerLevel"];

_dialog = uiNameSpace getVariable ["RscExileLockerDialog", displayNull];

_lockerAmount = player getVariable ["ExileLocker", 0];

// ========================================
// LEVEL SYSTEM: Dynamic Locker Limit
// ========================================
_playerLevel = player getVariable ["ExileLevel", 1];
_lockerLimit = call ExileClient_LevelSystem_getLockerLimit;

// Fallback
if (isNil "_lockerLimit" || _lockerLimit == 0) then {
	_lockerLimit = getNumber(missionConfigFile >> "CfgLocker" >> "maxDeposit");
};
// ========================================

_depositInput = _dialog displayCtrl 4006;
_depositInput ctrlSetText "";
_withdrawInput = _dialog displayCtrl 4005;
_withdrawInput ctrlSetText "";

_lockerAmountLabel = _dialog displayCtrl 4000;
_lockerAmountLabel ctrlSetStructuredText (parseText format["<t size='1.4'>%1 / %2 <img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='1' shadow='true' /></t>", _lockerAmount, _lockerLimit]);

// Get inventory money (multiple fallbacks)
_inventoryAmount = player getVariable ["ExileMoney", 0];

// Fallback
if (_inventoryAmount == 0) then {
    _inventoryAmount = ExileClientPlayerMoney;
};

if (isNil "_inventoryAmount") then {
    _inventoryAmount = 0;
};

diag_log format["[LevelSystem] Locker Response - Player Money: %1", _inventoryAmount];

_inventoryAmountLabel = _dialog displayCtrl 4001;
_inventoryAmountLabel ctrlSetStructuredText (parseText format["<t size='1.4'>%1 <img image='\exile_assets\texture\ui\poptab_inline_ca.paa' size='1' shadow='true' /></t>", _inventoryAmount]);

true