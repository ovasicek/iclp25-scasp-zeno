% ----- narrative & queries  -----

initiallyP(water_left(0)).
initiallyN(F) :- not initiallyP(F).

happens(start(left),        10).

happens(switch_right,       13).    % switch while below target
?- holdsAt(water_left(X),   13).    % 30

?- happens(switch_left,     T).     % non-term., should be smallest T > 13 
?- holdsAt(water_left(X),   15).    % non-term., should be 50


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
