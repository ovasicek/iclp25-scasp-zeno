% problems:
%   repeated trigger           - no longer present (one exact timepoint for triggering)
%   zero delay circular events - fixed by adding a delay via remodelling

#include './preprocessed_can_rules/model-fixed-event_delay-preprocessed.pl'. % include the can_* rules
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

delay(1).
happens(turn_light_off, T2) :- !spy,
    T1 .>. 0, max_time(Tmax), T2 .=<. Tmax,
    delay(D), T1 .=. T2 - D,
    happens(turn_light_on, T1).

happens(turn_light_on, T2) :- !spy,
    T1 .>. 0, max_time(Tmax), T2 .=<. Tmax,
    delay(D), T1 .=. T2 - D,
    happens(turn_light_off, T1).


% ----- narrative & queries  -----

% initiallyN(light_on). % no initial value means no triggers until the first event
happens(turn_light_on, 10).

?-     holdsAt(light_on,    5).    % no models
?- not_holdsAt(light_on,    5).    % no models

?-     holdsAt(light_on,    15).   % yes
?- not_holdsAt(light_on,    15).   % no models
?-     holdsAt(light_on,    16).   % no models
?- not_holdsAt(light_on,    16).   % yes

?- T .=<. 20,     holdsAt(light_on,   T). % (10,11], (12,13], (14,15], (16,17], (18,19]
?- T .=<. 20, not_holdsAt(light_on,   T). % (11,12], (13,14], (15,16], (17,18], (19,20]
?- T .=<. 20, happens(turn_light_off, T). % 11, 13, 15, 17, 19
?- T .=<. 20, happens(turn_light_on,  T). % 10, 12, 14, 16, 18, 20


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */