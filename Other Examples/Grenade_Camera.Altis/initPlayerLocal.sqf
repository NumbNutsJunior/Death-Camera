waitUntil {!isNull player};

player addEventHandler ["FiredMan", {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_vehicle"];

    if (_magazine isEqualTo "HandGrenade") then {
        life_grenade_target = _projectile;

        // Create death camera
        life_grenade_camera = "camera" camCreate (getPosASLVisual (vehicle life_grenade_target));
        life_grenade_camera camCommit 0;
        showCinemaBorder true;

        // Track vehicle of player
        addMissionEventHandler ["EachFrame", {

            // Error check
            if ((isNull life_grenade_target) || (isNull life_grenade_camera)) then {

                // Exit the death camera
                removeMissionEventHandler ["EachFrame", _thisEventHandler];
                life_grenade_camera cameraEffect ["terminate", "back"];
                camDestroy life_grenade_camera;
                life_grenade_target = objNull;
            } else {

                // Init
                private _unit = life_grenade_target;
                private _vehicle = if (!isNull (objectParent _unit)) then {objectParent _unit} else {_unit};
                private _positionVehicle = getPosASLVisual _vehicle;

                // Figure max camera distance
                private _distance3D = [0, 3.5, 4.5];
                _distance3D = if !(_vehicle isEqualTo _unit) then {_distance3D vectorMultiply 2} else {_distance3D};

                // Get relative distance 
                private _relativePosition = AGLToASL (_vehicle modelToWorldVisual _distance3D);
                _relativePosition set [2, (_positionVehicle select 2) + (_distance3D select 2)];

                // Draw a line to check if line of sight was comprimised
                private _intersections = lineIntersectsSurfaces [_positionVehicle, _relativePosition, _vehicle, _unit];

                // Check for any intersections
                if ((count _intersections) isEqualTo 1) then {

                    // Fetch intersected surface
                    private _surface = _intersections select 0;
                    if (([_surface select 2, _surface select 3] findIf {(isNull _x) || (_x isKindOf "Man")}) isEqualTo -1) then {

                        // Update relative position
                        _relativePosition = _surface select 0;
                    };
                };

                // Update camera target
                life_grenade_camera camSetTarget _vehicle;
                life_grenade_camera camCommit 0;

                // Update camera position
                life_grenade_camera setPosASL _relativePosition;
            };
        }];

        // Enter camera view
        life_grenade_camera cameraEffect ["internal", "back"];
    };
}];