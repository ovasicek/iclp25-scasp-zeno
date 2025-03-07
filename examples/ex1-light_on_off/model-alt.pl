#include './preprocessed_can_rules/model-preprocessed.pl'. % include the can_* rules
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

initiates(turn_light_on,  light_on, T) :- !spy,
    not_holdsAt(light_on, T).
terminates(turn_light_off, light_on, T) :- !spy,
    holdsAt(light_on, T).


% ----- narrative & queries  -----

initiallyN(light_on).
happens(turn_light_on,      10).
happens(turn_light_off,     20).

?-     holdsAt(light_on,    5).     % no models
?- not_holdsAt(light_on,    5).     % yes

?-     holdsAt(light_on,    15).    % yes
?- not_holdsAt(light_on,    15).    % no models

?-     holdsAt(light_on,    25).    % no models
?- not_holdsAt(light_on,    25).    % yes

?- not_holdsAt(light_on,    T).     % T #>= 0,T #=< 10; T #> 20,T #=< 100
?-     holdsAt(light_on,    T).     % T #> 10,T #=< 20


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */