/**
 * ExileClient_gui_traderDialog_event_onSellButtonClick
 * MODIFIED: Level System XP on sell
 */
 
private["_dialog","_sellButton","_purchaseButton","_inventoryListBox","_selectedInventoryListBoxIndex","_itemClassName","_quantity","_inventoryDropdown","_selectedInventoryDropdownIndex","_currentContainerType","_containerNetID","_container","_retardCheck"];
disableSerialization;
if !(uiNameSpace getVariable ["RscExileTraderDialogIsInitialized", false]) exitWith {};
_dialog = uiNameSpace getVariable ["RscExileTraderDialog", displayNull];
_sellButton = _dialog displayCtrl 4007;
_sellButton ctrlEnable false;
_sellButton ctrlCommit 0;
_purchaseButton = _dialog displayCtrl 4010;
_purchaseButton ctrlEnable false;
_purchaseButton ctrlCommit 0;
_inventoryListBox = _dialog displayCtrl 4005;
_selectedInventoryListBoxIndex = lbCurSel _inventoryListBox;
if !(_selectedInventoryListBoxIndex isEqualTo -1) then
{
	_itemClassName = _inventoryListBox lbData _selectedInventoryListBoxIndex;
	_quantity = 1; 
	if !(_itemClassName isEqualTo "") then
	{
		if !(ExileClientIsWaitingForServerTradeResponse) then
		{
			_inventoryDropdown = _dialog displayCtrl 4004;
			_selectedInventoryDropdownIndex = lbCurSel _inventoryDropdown;
			_currentContainerType = _inventoryDropdown lbValue _selectedInventoryDropdownIndex;
			_containerNetID = "";
			if (_currentContainerType isEqualTo 5) then
			{
				_containerNetID = _inventoryDropdown lbData _selectedInventoryDropdownIndex;
				_container = objectFromNetId _containerNetID;
				_retardCheck = _container call ExileClient_util_containerCargo_list;
			}
			else
			{
				_retardCheck = player call ExileClient_util_playerCargo_list;
			};
			if (_itemClassName in _retardCheck) then
			{
				ExileClientIsWaitingForServerTradeResponse = true;
				["sellItemRequest", [_itemClassName, _quantity, _currentContainerType, _containerNetID]] call ExileClient_system_network_send;
				
				// ========================================
				// LEVEL SYSTEM: Award XP for trading
				// ========================================
				if (!isNil "ExileClientLevelSystemXPRewards") then 
				{
					private _xpAmount = [ExileClientLevelSystemXPRewards, "Trading"] call BIS_fnc_getFromPairs;
					
					if (!isNil "_xpAmount" && _xpAmount > 0) then 
					{
						[_xpAmount, "Trading"] call ExileClient_LevelSystem_addXP;
						
						if (ExileClientLevelSystemShowNotifications) then 
						{
							["SuccessTitleAndText", ["XP Gewonnen!", format["+%1 XP für Trading", _xpAmount]]] call ExileClient_gui_toaster_addTemplateToast;
						};
					};
				};
			};
		};
	};
};
true