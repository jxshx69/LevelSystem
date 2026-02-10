/**
 * ExileServer_system_locker_network_lockerDepositRequest
 * MODIFIED: Dynamic locker limit based on level (SERVER-SIDE ONLY)
 */
 
private["_sessionID","_parameters","_deposit","_player","_depositAmount","_playerMoney","_lockerLimit","_lockerAmount","_newLockerAmount","_newPlayerMoney","_playerLevel","_lockerLimits","_maxLevel"];
_sessionID = _this select 0;
_parameters = _this select 1;
_deposit = _parameters select 0;

try
{
	_player = _sessionID call ExileServer_system_session_getPlayerObject;
	if (isNull _player) then
	{
		throw "Null player";
	};
	if !(alive _player) then
	{
		throw "Dead player";
	};
	_depositAmount = parseNumber _deposit;
	_playerMoney = _player getVariable ["ExileMoney",0];
	if (_playerMoney < _depositAmount) then
	{
		throw "Not enough pop tabs";
	};
	
	// ========================================
	// LEVEL SYSTEM: Dynamic Locker Limit
	// ========================================
	_playerLevel = _player getVariable ["ExileLevel", 1];
	
	_lockerLimits = [
		500000,1000000,1500000,2000000,2500000,3000000,3500000,4000000,4500000,5000000,5500000,6000000,6500000,7000000,7500000,8000000,8500000,9000000,10000000,15000000
	];
	
	_maxLevel = count _lockerLimits;
	if (_playerLevel < 1) then { _playerLevel = 1; };
	if (_playerLevel > _maxLevel) then { _playerLevel = _maxLevel; };
	_lockerLimit = _lockerLimits select (_playerLevel - 1);
	
	diag_log format["[LevelSystem] Deposit Check - Player: %1, Level: %2, Limit: %3", name _player, _playerLevel, _lockerLimit];
	// ========================================
	
	_lockerAmount = _player getVariable ["ExileLocker", 0];
	_newLockerAmount = _depositAmount + _lockerAmount;
	
	if (_lockerLimit < _newLockerAmount) then
	{
		throw format["Your locker can only hold %1 pop tabs (Level %2 limit)", _lockerLimit, _playerLevel];
	};
	
	_player setVariable ["ExileLocker", _newLockerAmount, true];
	format["updateLocker:%1:%2", _newLockerAmount, getPlayerUID _player] call ExileServer_system_database_query_fireAndForget;
	_newPlayerMoney = _playerMoney - _depositAmount;
	_player setVariable ["ExileMoney", _newPlayerMoney, true];
	format["setPlayerMoney:%1:%2", _newPlayerMoney, _player getVariable ["ExileDatabaseID", 0]] call ExileServer_system_database_query_fireAndForget;
	
	[_sessionID, "toastRequest", ["SuccessTitleOnly", ["Deposited!"]]] call ExileServer_system_network_send_to;
	[_sessionID, "lockerResponse", []] call ExileServer_system_network_send_to;
	
	diag_log format["[LevelSystem] ✅ Deposit OK - New amount: %1/%2", _newLockerAmount, _lockerLimit];
}
catch 
{
	_exception call ExileServer_util_log;
	diag_log format["[LevelSystem] ❌ Deposit failed: %1", _exception];
	[_sessionID, "toastRequest", ["ErrorTitleAndText", ["Deposit Failed!", _exception]]] call ExileServer_system_network_send_to;
};

true