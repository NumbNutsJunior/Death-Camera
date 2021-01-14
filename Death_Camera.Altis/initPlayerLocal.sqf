waitUntil {!isNull (findDisplay 46)};

player switchCamera "External";
enableSaving [false, false];
player enableFatigue false;
player allowDamage false;
enableTeamSwitch false;

// Save inital loadout
life_spawn_loadout = getUnitLoadout player;

// Setup configuration
call life_fnc_configuration;

// Setup actions
call life_fnc_setupActions;