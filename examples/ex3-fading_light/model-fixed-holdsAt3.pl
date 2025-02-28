#include './preprocessed_can_rules/model-preprocessed.pl'. % include the can_* rules
#show happens/2, holdsAt/2.
#show stoppedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).                      % it is useful to have an upper bound on time for the full axioms


% ----- domain model -----

event(turn_light_on).           % start brightening from zero to max
event(full_brightness_reached). % stop brightening at max

fluent(fading_in).
fluent(light_intensity(X)).     % range 0-10

initiates(turn_light_on, fading_in, T).
releases(turn_light_on, light_intensity(X), T).

terminates(full_brightness_reached, fading_in, T).
initiates(full_brightness_reached, light_intensity(10), T).
terminates(full_brightness_reached, light_intensity(X), T) :- X .<>. 10.

trajectory(fading_in, T1, light_intensity(NewI), T2) :-
    NewI .=. OldI + ((T2-T1) * 1),
    holdsAt(light_intensity(OldI), T1).

happens(full_brightness_reached, T) :- !spy,
    holdsAt(light_intensity(10), T, fading_in).


% ----- narrative & queries  -----

initiallyP(light_intensity(0)).
initiallyN(F) :- not initiallyP(F).

happens(turn_light_on, 10).

?- happens(light_intensity(X),      25). % 10
?- happens(full_brightness_reached, T).  % 20


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
