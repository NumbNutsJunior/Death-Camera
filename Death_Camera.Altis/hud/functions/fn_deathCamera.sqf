
// Author: Pizza Man
// File: fn_deathCamera.sqf
// Description: Track the vehicle of the dead unit with a camera.

// Create death camera
life_death_camera = "camera" camCreate (getPosASLVisual (vehicle life_dead_body));
life_death_camera camCommit 0;
showCinemaBorder true;

// Track vehicle of player
addMissionEventHandler ["EachFrame", {

	// Error check
	if ((isNull life_dead_body) || (isNull life_death_camera)) then {

		// Exit the death camera
		removeMissionEventHandler ["EachFrame", _thisEventHandler];
		life_death_camera cameraEffect ["terminate", "back"];
		camDestroy life_death_camera;
		life_dead_body = objNull;
	} else {

		// Init
		private _unit = life_dead_body;
		private _vehicle = if (!isNull (objectParent _unit)) then {objectParent _unit} else {vehicle _unit};

		// Figure target position
		private _positionVehicle = getPosASLVisual _vehicle;
		private _positionUnit = AGLToASL (_unit modelToWorldVisual (_unit selectionPosition "pelvis"));
		private _position = if (_vehicle isEqualTo _unit) then {_positionUnit} else {_positionVehicle};
		_positionVehicle = nil;
		_positionUnit = nil;

		// Figure max camera distance
		private _distance3D = [0, 3.5, 4.5];
		_distance3D = if !(_vehicle isEqualTo _unit) then {_distance3D vectorMultiply 2} else {_distance3D};

		// Get relative distance 
		private _relativePosition = AGLToASL (_vehicle modelToWorldVisual _distance3D);
		_relativePosition set [2, (_position select 2) + (_distance3D select 2)];

		// Draw a line to check if line of sight was comprimised
		private _intersections = lineIntersectsSurfaces [_position, _relativePosition, _vehicle, _unit];

		// Check for any intersections
		if ((count _intersections) isEqualTo 1) then {

			// Fetch intersected surface
			private _surface = _intersections select 0;
			if (([_surface select 2, _surface select 3] findIf {(isNull _x) || (_x isKindOf "Man")}) isEqualTo -1) then {
				if !((_position distance (_surface select 0)) <= 1) then {

					// Update relative position
					_relativePosition = _surface select 0;
				};
			};
		};

		// Update camera position
		life_death_camera setPosASL _relativePosition;

		// Update camera target
		life_death_camera camSetTarget (getPosVisual _unit);
		life_death_camera camCommit 0;
	};
}];

// Enter camera view
life_death_camera cameraEffect ["internal", "back"];
