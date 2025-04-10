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

epsilon(1/1000000).
happens(turn_light_off, T) :- !spy,
    epsilon(EPS),
    holdsAt(light_on, T, EPS, turn_light_on).


% ----- narrative & queries  -----

initiallyN(light_on).
happens(turn_light_on,      10).

?-     holdsAt(light_on,    5).     % no models
?- not_holdsAt(light_on,    5).     % yes

?- happens(turn_light_off,  T).

/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/
?-     holdsAt(light_on,    15).    % no models
?- not_holdsAt(light_on,    15).    % yes

?- not_holdsAt(light_on,    T).     % T #>= 0,T #=< 10; T #> 10.0,T #=< 100
?-     holdsAt(light_on,    T).     % T #> 10,T #=< 10.0



/* ------------------------------ end of file ------------------------------ */