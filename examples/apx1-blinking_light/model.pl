% problems:
%   repeated trigger           - manifests in the "zero delay circular events" problem
%   zero delay circular events - needs to be fixed

#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).                      % it is useful to have an upper bound on time for the full axioms


% ----- domain model -----

event(turn_light_on).
event(turn_light_off).

fluent(light_on).

initiates(turn_light_on,  light_on, T).
terminates(turn_light_off, light_on, T).

happens(turn_light_off, T) :- !spy,
    holdsAt(light_on, T).

happens(turn_light_on, T) :- !spy,
    not_holdsAt(light_on, T).


% ----- narrative & queries  -----

% initiallyN(light_on). % no initial value means no triggers until the first event
happens(turn_light_on,      10).

?-     holdsAt(light_on,    5).    % non-term., should be no models
?- not_holdsAt(light_on,    5).    % non-term., should be no models

?-     holdsAt(light_on,    15).   % non-term., should be ??
?- not_holdsAt(light_on,    15).   % non-term., should be ??

?- T .=<. 20, happens(turn_light_off, T). % non-term., should be ??
?- T .=<. 20, happens(turn_light_on,  T). % non-term., should be 10 and ??


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */