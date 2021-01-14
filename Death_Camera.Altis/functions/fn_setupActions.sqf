{player removeAction _x} forEach life_actions;

// Actions
life_actions pushBack (player addAction ["<t color='#FF0000'>Kill Yourself</t>", {player setDamage 1}, [], 0, false]);
//life_actions pushBack (player addAction ["<t color='#FF0000'>Kill Yourself</t>", life_fnc_deathCamera, [], 0, false]);