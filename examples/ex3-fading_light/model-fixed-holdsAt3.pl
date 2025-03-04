#include './preprocessed_can_rules/model-fixed-holdsAt3-preprocessed.pl'. % include the can_* rules
#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).                      % it is useful to have an upper bound on time for the full axioms


% ----- domain model -----

event(turn_light_on).   % start brightening from zero to max
event(fade_in_end).     % stop brightening at max

fluent(fading_in).
fluent(brightness(X)).  % range 0-10

initiates(turn_light_on, fading_in, T).
releases(turn_light_on, brightness(X), T).

terminates(fade_in_end, fading_in, T).
initiates(fade_in_end, brightness(10), T).
terminates(fade_in_end, brightness(X), T) :- X .<>. 10.

trajectory(fading_in, T1, brightness(NewI), T2) :-
    NewI .=. OldI + ((T2-T1) * 1),
    holdsAt(brightness(OldI), T1).

happens(fade_in_end, T) :- !spy,
    holdsAt(brightness(10), T, fading_in).


% ----- narrative & queries  -----

initiallyP(brightness(0)).
initiallyN(F) :- not initiallyP(F).

happens(turn_light_on, 10).

?- holdsAt(brightness(X),   25). % 10
?- happens(fade_in_end,     T).  % 20


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
