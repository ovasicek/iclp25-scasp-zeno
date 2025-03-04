#include './preprocessed_can_rules/model-fixed-context_free-preprocessed.pl'. % include the can_* rules
#show happens/2, not_happens/2, 
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).              % it is useful to have an upper bound on time for the full axioms


% ----- domain model -----

event(turn_light_on).       % start the fading process
event(turn_light_off).      % stop the fading process
event(switch_fade_in).      % start brightening from zero to max
event(switch_fade_out).     % start dimming from max to zero


fluent(fading_in).
fluent(fading_out).
fluent(brightness(X)).      % range 0-10
fluent(light_on).


initiates(turn_light_on, light_on, T).
initiates(turn_light_on, fading_in, T).
releases(turn_light_on, brightness(X), T).

terminates(turn_light_off, light_on, T).
terminates(turn_light_off, fading_in, T) :- holdsAt(fading_in, T).
terminates(turn_light_off, fading_out, T) :- holdsAt(fading_out, T).
initiates(turn_light_off, light_intensity(0), T).
terminates(turn_light_off, light_intensity(X), T) :- X .<>. 0.

initiates(switch_fade_in, fading_in, T).
terminates(switch_fade_in, fading_out, T).

initiates(switch_fade_out, fading_out, T).
terminates(switch_fade_out, fading_in, T).

can_trajectory(fading_in, T1, brightness(NewLevel), T2) :-
    NewLevel .=. 0 + ((T2-T1) * 1).
trajectory(fading_in, T1, brightness(NewLevel), T2) :-  %//NO_PREPROCESS
    NewLevel .=. OldLevel + ((T2-T1) * 1),
    holdsAt(brightness(OldLevel), T1).

can_trajectory(fading_out, T1, brightness(NewLevel), T2) :-
    NewLevel .=. 10 - ((T2-T1) * 1).
trajectory(fading_out, T1, brightness(NewLevel), T2) :- %//NO_PREPROCESS
    NewLevel .=. OldLevel - ((T2-T1) * 1),
    holdsAt(brightness(OldLevel), T1).


happens(switch_fade_out, T) :- !spy,
    holdsAt(light_on, T),
    holdsAt(brightness(10), T, fading_in).

happens(switch_fade_in, T) :- !spy,
    holdsAt(light_on, T),
    holdsAt(brightness(0), T, fading_out).


% ----- narrative & queries  -----

initiallyP(brightness(0)).
initiallyN(F) :- not initiallyP(F).

happens(turn_light_on, 10).
happens(turn_light_off, 45).

?- holdsAt(brightness(X),   10).    % 0

?- happens(switch_fade_out, 20).
?- holdsAt(brightness(X),   20).    % 10

?- happens(switch_fade_in,  30).
?- holdsAt(brightness(X),   30).    % 0

?- happens(switch_fade_out, 40).
?- holdsAt(brightness(X),   40).    % 10

?- happens(switch_fade_out, T).     % 20, 40
?- happens(switch_fade_in,  T).     % 30

/*

/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
