#include './model-preprocessed.pl'. % include the can_* rules
#show happens/2, not_happens/2.
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

epsilon(1/1000000).             % arbitrarily small epsilon
happens(turn_light_off, T2) :-
    !spy,                       % prints resolution tree for making the trace
    epsilon(EPS), T2 .=. T1 + EPS,
    happens(turn_light_on, T1),
    holdsAt(light_on, T2).

% narrative & queries
initiallyN(light_on).
happens(turn_light_on, 10).

?- holdsAt(light_on, T).        % T #> 10,T #=< 10.0
?- happens(turn_light_off, T).  % 10.0
/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/


/* ------------------------------ end of file ------------------------------ */