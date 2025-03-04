#include './model-preprocessed.pl'. % include the can_* rules
#show happens/2, not_happens/2, 
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).                      % it is useful to have an upper bound on time for the full axioms

% domain model
fluent(light_on).
event(turn_light_on).
event(turn_light_off).

initiates(turn_light_on,  light_on, T).
terminates(turn_light_off, light_on, T).

happens(turn_light_off, T) :-
    !spy,                   % prints resolution tree for making the trace
    holdsAt(light_on, T).

% narrative & queries
initiallyN(light_on).
happens(turn_light_on, 10).

?- holdsAt(light_on, T).        % non-terminating
?- happens(turn_light_off, T).  % non-terminating
/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/


/* ------------------------------ end of file ------------------------------ */