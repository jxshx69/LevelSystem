/**
 * ExileServer_object_player_createBambi
 *
 * Exile Mod
 * www.exilemod.com
 * © 2015 Exile Mod Team
 *
 * This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License.
 * To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-nd/4.0/.
 * 
 * CUSTOM MODIFICATIONS:
 * - Most-Wanted System
 * - Player Title System
 * - Level System Auto-Load
 */

private["_sessionID","_requestingPlayer","_spawnLocationMarkerName","_bambiPlayer","_accountData","_direction","_position","_spawnAreaPosition","_spawnAreaRadius","_clanID","_clanData","_clanGroup","_devFriendlyMode","_devs","_parachuteNetID","_spawnType","_parachuteObject","_playerUID","_playerTitle","_queryResult","_charArray","_cleanArray","_name","_bounty","_lock","_interval","_immunity","_levelData","_playerLevel","_playerXP"];

_sessionID = _this select 0;
_requestingPlayer = _this select 1;
_spawnLocationMarkerName = _this select 2;
_bambiPlayer = _this select 3;
_accountData = _this select 4;
_direction = random 360;

// ========================================
// SPAWN POSITION ERMITTELN
// ========================================
if ((count ExileSpawnZoneMarkerPositions) isEqualTo 0) then
{
	_position = call ExileClient_util_world_findCoastPosition;
	if ((toLower worldName) isEqualTo "namalsk") then
	{
		while {(_position distance2D [76.4239, 107.141, 0]) < 100} do
		{
			_position = call ExileClient_util_world_findCoastPosition;
		};
	};
}
else
{
	_spawnAreaPosition = getMarkerPos _spawnLocationMarkerName;
	_spawnAreaRadius = getNumber(configFile >> "CfgSettings" >> "BambiSettings" >> "spawnZoneRadius");
	_position = [_spawnAreaPosition, _spawnAreaRadius] call ExileClient_util_math_getRandomPositionInCircle;
	while {surfaceIsWater _position} do
	{
		_position = [_spawnAreaPosition, _spawnAreaRadius] call ExileClient_util_math_getRandomPositionInCircle;
	};
};

_playerUID = getPlayerUID _requestingPlayer;
_name = name _requestingPlayer;

diag_log format["[BAMBI] Creating bambi for %1 (UID: %2)", _name, _playerUID];

// ========================================
// MOST-WANTED SYSTEM
// ========================================
_interval = getNumber(missionConfigFile >> "CfgMostWanted" >> "Database" >> "Immunity" >> "interval");
_immunity = format ["hasImmunity:%1:%2",_playerUID,_interval] call ExileServer_system_database_query_selectSingleField;
_bambiPlayer setVariable ["ExileBountyImmunity", _immunity, true];

_bounty = format ["getBounty:%1",_playerUID] call ExileServer_system_database_query_selectSingle;
_bambiPlayer setVariable ["ExileBounty",_bounty select 0];
_lock = false;
if ((_bounty select 1) isEqualTo 1) then
{
	_lock = true;
};
_bambiPlayer setVariable ["ExileBountyLock",_lock,true];
_bambiPlayer setVariable ["ExileBountyContract",_bounty select 2,true];
_bambiPlayer setVariable ["ExileBountyCompletedContracts",_bounty select 3];
_bambiPlayer setVariable ["ExileBountyFriends",_bounty select 4,true];
diag_log format["[BAMBI] Most-Wanted data loaded for %1", _name];

// ========================================
// PLAYER TITLE SYSTEM
// ========================================
_playerTitle = "";

try 
{
	_queryResult = format["getPlayerTitle:%1", _playerUID] call ExileServer_system_database_query_selectSingle;
	
	if (!isNil "_queryResult") then 
	{
		if ((typeName _queryResult) isEqualTo "ARRAY") then 
		{
			if ((count _queryResult) > 0) then 
			{
				_playerTitle = _queryResult select 0;
				
				if (_playerTitle != "") then 
				{
					_charArray = toArray _playerTitle;
					_cleanArray = [];
					{
						if (_x != 34) then 
						{
							_cleanArray pushBack _x;
						};
					} forEach _charArray;
					_playerTitle = toString _cleanArray;
				};
			};
		};
	};
}
catch 
{
	diag_log format["[BAMBI] Title Query Error: %1", _exception];
};

if (_playerTitle == "" || isNil "_playerTitle") then 
{
	_playerTitle = "Neuling";
};

_bambiPlayer setVariable ["ExilePlayerTitle", _playerTitle, true];
diag_log format["[BAMBI] Player Title: '%1'", _playerTitle];

// ========================================
// LEVEL SYSTEM - LOAD FROM DB
// ========================================
_playerLevel = 1;
_playerXP = 0;

diag_log format["[LevelSystem Bambi] Loading level for %1 (UID: %2)", _name, _playerUID];

try 
{
	_levelData = [_playerUID] call ExileServer_LevelSystem_database_loadLevel;
	
	if (!isNil "_levelData" && {typeName _levelData == "ARRAY"} && {count _levelData >= 2}) then 
	{
		_playerLevel = _levelData select 0;
		_playerXP = _levelData select 1;
		
		// Validate
		if (typeName _playerLevel != "SCALAR") then { _playerLevel = 1; };
		if (typeName _playerXP != "SCALAR") then { _playerXP = 0; };
		if (_playerLevel < 1) then { _playerLevel = 1; };
		if (_playerXP < 0) then { _playerXP = 0; };
		
		diag_log format["[LevelSystem Bambi] ✅ Loaded: Level %1, XP %2", _playerLevel, _playerXP];
	}
	else
	{
		diag_log "[LevelSystem Bambi] ⚠️ No data found, creating DB entry";
		format["createPlayerLevel:%1", _playerUID] call ExileServer_system_database_query_fireAndForget;
	};
}
catch 
{
	diag_log format["[LevelSystem Bambi] ❌ ERROR: %1", _exception];
	_playerLevel = 1;
	_playerXP = 0;
};

// ========================================
// SET LEVEL VARIABLES (LOCAL ONLY!)
// ========================================
_bambiPlayer setVariable ["ExileLevel", _playerLevel, false];  // ← false = LOCAL!
_bambiPlayer setVariable ["ExileXP", _playerXP, false];

diag_log format["[LevelSystem Bambi] Variables set: Level %1, XP %2", _playerLevel, _playerXP];

// ========================================
// CLAN SYSTEM
// ========================================
_clanID = (_accountData select 3);
if !((typeName _clanID) isEqualTo "SCALAR") then
{
	_clanID = -1;
	_clanData = [];
}
else
{
	_clanData = missionNamespace getVariable [format ["ExileServer_clan_%1",_clanID],[]];
	if(isNull (_clanData select 5))then
	{
		_clanGroup = createGroup independent;
		_clanData set [5,_clanGroup];
		_clanGroup setGroupIdGlobal [_clanData select 0];
		missionNameSpace setVariable [format ["ExileServer_clan_%1",_clanID],_clanData];
	}
	else
	{
		_clanGroup = (_clanData select 5);
	};
	[_bambiPlayer] joinSilent _clanGroup;
};

// ========================================
// BAMBI PLAYER SETUP
// ========================================
_bambiPlayer setPosATL [_position select 0,_position select 1,0];
_bambiPlayer disableAI "FSM";
_bambiPlayer disableAI "MOVE";
_bambiPlayer disableAI "AUTOTARGET";
_bambiPlayer disableAI "TARGET";
_bambiPlayer disableAI "CHECKVISIBLE";
_bambiPlayer setDir _direction;
_bambiPlayer setName _name;
_bambiPlayer setVariable ["ExileMoney", 0, true];
_bambiPlayer setVariable ["ExileScore", (_accountData select 0)];
_bambiPlayer setVariable ["ExileKills", (_accountData select 1)];
_bambiPlayer setVariable ["ExileDeaths", (_accountData select 2)];
_bambiPlayer setVariable ["ExileClanID", _clanID];
_bambiPlayer setVariable ["ExileClanData", _clanData];
_bambiPlayer setVariable ["ExileHunger", 100];
_bambiPlayer setVariable ["ExileThirst", 100];
_bambiPlayer setVariable ["ExileTemperature", 37];
_bambiPlayer setVariable ["ExileWetness", 0];
_bambiPlayer setVariable ["ExileAlcohol", 0];
_bambiPlayer setVariable ["ExileName", _name];
_bambiPlayer setVariable ["ExileOwnerUID", _playerUID];
_bambiPlayer setVariable ["ExileIsBambi", true];
_bambiPlayer setVariable ["ExileXM8IsOnline", false, true];
_bambiPlayer setVariable ["ExileLocker", (_accountData select 4), true];

// ========================================
// DEV FRIENDLY MODE
// ========================================
_devFriendlyMode = getNumber (configFile >> "CfgSettings" >> "ServerSettings" >> "devFriendyMode");
if (_devFriendlyMode isEqualTo 1) then
{
	_devs = getArray (configFile >> "CfgSettings" >> "ServerSettings" >> "devs");
	{
		if (_playerUID isEqualTo (_x select 0))exitWith
		{
			if(_name isEqualTo (_x select 1))then
			{
				_bambiPlayer setVariable ["ExileMoney", 500000, true];
				_bambiPlayer setVariable ["ExileScore", 100000];
			};
		};
	}
	forEach _devs;
};

// ========================================
// PARACHUTE SPAWN
// ========================================
_parachuteNetID = "";
if ((getNumber(configFile >> "CfgSettings" >> "BambiSettings" >> "parachuteSpawning")) isEqualTo 1) then
{
	_position set [2, getNumber(configFile >> "CfgSettings" >> "BambiSettings" >> "parachuteDropHeight")];
	if ((getNumber(configFile >> "CfgSettings" >> "BambiSettings" >> "haloJump")) isEqualTo 1) then
	{
		_bambiPlayer addBackpackGlobal "B_Parachute";
		_bambiPlayer setPosATL _position;
		_spawnType = 2;
	}
	else
	{
		_parachuteObject = createVehicle ["Steerable_Parachute_F", _position, [], 0, "CAN_COLLIDE"];
		_parachuteObject setDir _direction;
		_parachuteObject setPosATL _position;
		_parachuteObject enableSimulationGlobal true;
		_parachuteNetID = netId _parachuteObject;
		_spawnType = 1;
	};
}
else
{
	_spawnType = 0;
};

// ========================================
// EVENT HANDLERS & DATABASE
// ========================================
_bambiPlayer addMPEventHandler ["MPKilled", {_this call ExileServer_object_player_event_onMpKilled}];
_bambiPlayer call ExileServer_object_player_database_insert;
_bambiPlayer call ExileServer_object_player_database_update;

// ========================================
// SEND TO CLIENT - CREATE PLAYER RESPONSE
// ========================================
[
	_sessionID,
	"createPlayerResponse",
	[
		_bambiPlayer,
		_parachuteNetID,
		str (_accountData select 0),
		(_accountData select 1),
		(_accountData select 2),
		100,
		100,
		0,
		(getNumber (configFile >> "CfgSettings" >> "BambiSettings" >> "protectionDuration")) * 60,
		_clanData,
		_spawnType
	]
]
call ExileServer_system_network_send_to;

// ========================================
// SEND TO CLIENT - MOST-WANTED UPDATE
// ========================================
[
	_sessionID,
	"updateCompletedContracts",
	[
		_bounty select 3
	]
] 
call ExileServer_system_network_send_to;

// ========================================
// SEND TO CLIENT - PLAYER TITLE TOAST
// ========================================
[
	_sessionID,
	"toastRequest",
	[
		"InfoTitleAndText",
		["Willkommen zurück!", format["Dein Titel: %1", _playerTitle]]
	]
] 
call ExileServer_system_network_send_to;

// ========================================
// SEND TO CLIENT - LEVEL SYSTEM DATA
// ========================================
[
	_sessionID, 
	"loadLevelResponse", 
	[
		_playerLevel,
		_playerXP
	]
] 
call ExileServer_system_network_send_to;

diag_log format["[LevelSystem Bambi] ✅ Sent to client: Level %1, XP %2", _playerLevel, _playerXP];

// ========================================
// SESSION UPDATE
// ========================================
[_sessionID, _bambiPlayer] call ExileServer_system_session_update;

diag_log format["[BAMBI] ✅ Player %1 successfully spawned with Level %2 (%3 XP)", _name, _playerLevel, _playerXP];

_bambiPlayer