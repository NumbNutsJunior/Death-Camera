
// Event parameters
params [["_aliveUnit", objNull], ["_deadUnit", objNull]];

// Assign spawn loadout to player again
player setUnitLoadout life_spawn_loadout;

// Update current dead body
life_dead_body = _deadUnit;

// Show death screen
[] call life_fnc_deathCamera;

// Setup actions
[] call life_fnc_setupActions;