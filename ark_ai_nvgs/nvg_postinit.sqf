addMissionEventHandler ["EntityKilled", {
    private _unit = _this select 0;
    private _hmd = hmd _unit;
    if (_hmd == "NVGoggles_AI") then {
        _unit unlinkItem _hmd;
    };
}];