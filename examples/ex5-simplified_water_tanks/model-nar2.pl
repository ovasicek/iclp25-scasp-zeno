% ----- narrative & queries  -----

initiallyP(water_left(0)).
initiallyN(F) :- not initiallyP(F).

?- holdsAt(water_left(X),       5).     % 0

happens(start(left),            10).
?- holdsAt(water_left(X),       12).    % 20

happens(switch_right,           13).    % switch while below target
?- holdsAt(water_left(X),       13).    % 30

?- happens(switch_left,         T).     % non-term., should be smallest T > 13 
?- holdsAt(water_left(X),       15).    % non-term., should be 50


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
