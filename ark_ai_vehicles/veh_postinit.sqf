[] spawn {
    while {true} do {
        {
            if (_x isKindOf "LandVehicle" && (count crew _x > 0) && !(_x isKindOf "StaticWeapon") && alive _x  && simulationEnabled _x) then {
                private _isEHAlreadyApplied = _x getVariable ["ark_ai_vehicles_repair_eh_applied", false];
                    if !(_isEHAlreadyApplied) then {
                        _x addEventHandler ["Hit", {call ark_fnc_vehicleHit}];
                        _x setVariable ["ark_ai_vehicles_repair_eh_applied", true, true];
                    };

                if ((!alive (gunner _x)) && alive (driver _x) && !((driver _x) in PlayableUnits)) then {
                    [_x] remoteExecCall ["ark_fnc_vehicleGunnerDead", _x, false];
                };

                if (!canMove _x && !isNull (driver _x) && !((driver _x) in PlayableUnits)) then {
                    [_x] remoteExecCall ["ark_fnc_vehicleRepair", _x, false];
                };
            };
        } forEach vehicles;
        sleep 15;
    };
};

ark_fnc_vehicleHit = {
    private _vehicle = _this select 0;

    _vehicle setVariable ["ark_ai_vehicles_last_hit", time, true];
};

ark_fnc_vehicleGunnerDead = {
    private _vehicle = _this select 0;
    private _driver = driver _vehicle;
    private _allTurrets = allTurrets _vehicle;
    
    if (count _allTurrets == 0 || isnil "_allTurrets") exitWith {};
    _vehicle setVariable ["ark_ai_vehicles_gunner_dead", true, true];

    [_vehicle,_driver] spawn {
        params ["_vehicle","_driver"];

        _vehicle forceSpeed 0;
        sleep 4;
        doGetOut _driver;
        sleep 2;
        _driver moveInGunner _vehicle;
    };
};

ark_fnc_vehicleRepair = {
    private _vehicle = _this select 0;
    private _driver = driver _vehicle;
    private _gunner = gunner _vehicle;
    private _vehicleClassName = typeOf _vehicle;

    private _cookingOff = _vehicle getVariable ["ACE_cookoff_isCookingOff", false];
    private _driverUnconscious = _driver getVariable ["ACE_isUnconscious", false];
    private _waitingToRepair = _vehicle getVariable ["ark_ai_vehicles_awaiting_repair", false];
    private _gunnerDead = _vehicle getVariable ["ark_ai_vehicles_gunner_dead", false];

    if (_cookingOff || _driverUnconscious || _waitingToRepair || _gunnerDead) exitWith {};

    if (_driver != _vehicle && alive _driver) then {

        _vehicle setVariable ["ark_ai_vehicles_awaiting_repair", true, true];

        [_vehicle,_driver,_vehicleClassName] spawn {
            params ["_vehicle","_driver","_vehicleClassName"];

            waitUntil {
              sleep 5;
              private _lastHit = _vehicle getVariable ["ark_ai_vehicles_last_hit", 0];
              private _outOfCombatDelayTime = _lastHit + 10;

              (time >= _outOfCombatDelayTime || time - _lastHit > 30);
            };

            _vehicle forceSpeed 0;
            sleep 2;

            {_driver disableAI _x;} forEach ["TARGET", "AUTOTARGET", "PATH", "FSM", "AUTOCOMBAT"];
            doGetOut _driver;
            sleep 2;

            _driver setVectorDir (getpos _driver vectorFromTo getpos _vehicle);
            _driver playMoveNow "Acts_carFixingWheel";
            sleep 15;

            if (!alive _driver || !alive _vehicle) exitWith {
                _vehicle setVariable ["ark_ai_vehicles_awaiting_repair", false, true];
            };

            if (_vehicleClassName isKindOf "Car") then {
                {_vehicle setHit [getText(configFile >> "cfgVehicles" >> _vehicleClassName >> "HitPoints" >> _x >> "name"), 0, true];} forEach ["HitLFWheel", "HitLBWheel", "HitLMWheel", "HitLF2Wheel", "HitRFWheel", "HitRBWheel", "HitRMWheel", "HitRF2Wheel"];
            };

            if (_vehicleClassName isKindOf "Tank") then {
                {_vehicle setHit [getText(configFile >> "cfgVehicles" >> _vehicleClassName >> "HitPoints" >> _x >> "name"), 0, true];} forEach ["HitLTrack","HitRTrack"];
            } else {
                _vehicle setDamage 0;
            };

            _vehicle setPosATL [getPosATL _vehicle select 0, getPosATL _vehicle select 1, (getPosATL _vehicle select 2) + 0.5];

            _driver playMove "";
            _driver moveInDriver _vehicle;
            {_driver enableAI _x;} forEach ["TARGET", "AUTOTARGET", "PATH", "FSM", "AUTOCOMBAT"];

            // Horrible fix for engine bug (appeared in 1.70)
            private _vehGrp = group _vehicle;
            private _newWpIndex = count (waypoints _vehGrp);
            private _currentWp = currentWaypoint _vehGrp;
            private _tempWp = _vehGrp addWaypoint [[0,0,0], 0, _newWpIndex];

            _vehGrp setCurrentWaypoint [_vehGrp, _newWpIndex];

            sleep 6;

            _vehGrp setCurrentWaypoint [_vehGrp, _currentWp];
            deleteWaypoint [_vehGrp, _newWpIndex];

            _vehicle forceSpeed -1;
            _vehicle setVariable ["ark_ai_vehicles_awaiting_repair", false, true];
        };
    };
};