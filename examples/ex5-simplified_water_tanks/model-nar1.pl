% ----- narrative & queries  -----

initiallyP(water_left(100)).
initiallyN(F) :- not initiallyP(F).

?- holdsAt(water_left(X),       5).     % 100

happens(start(right),           10).
?- holdsAt(water_left(X),       12).    % 80

?- happens(switch_left,         15).    % yes
?- holdsAt(water_left(X),       15).    % 50

happens(switch_right,           18).
?- holdsAt(water_left(X),       18).    % 80

?- happens(switch_left,         21).    % yes
?- holdsAt(water_left(X),       21).    % 50

?- happens(switch_left,         T).     % 15, 21
?- holdsAt(water_left(X),       25).    % 90


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
