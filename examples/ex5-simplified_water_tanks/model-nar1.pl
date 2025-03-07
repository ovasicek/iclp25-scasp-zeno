% problems:
%   repeated trigger          - not present in this narrative
%   self-end trajectory       - fixed via holdsAt/3 (or holdsAt/4)
%   trajectory end at ineq.   - not present in this narrative

% ----- narrative & queries  -----

initiallyP(water_left(100)).
initiallyN(F) :- not initiallyP(F).

happens(start(right),       10).

?- happens(switch_left,     25/2).%(12.5)       % yes
?- holdsAt(water_left(X),   25/2).%(12.5)       % 50

happens(switch_right,       65/4).
?- holdsAt(water_left(X),   65/4).%(16.25)      % 87.5 (175/2)

?- happens(switch_left,     145/8).%(18.125)    % yes
?- holdsAt(water_left(X),   145/8).%(18.125)    % 50

happens(switch_right,       305/16).%(19.0625)  % yes
?- holdsAt(water_left(X),   305/16).%(19.0625)  % 59.375 (475/8)

?- happens(switch_left,     T).                 % 25/2 (12.5), 145/8 (18.125)
?- holdsAt(water_left(X),   19.5).              % 405/8 (50.625)


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
