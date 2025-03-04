#include './preprocessed_can_rules/model-fixed-incremental-preprocessed.pl'. % include the can_* rules
#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.



% ----- domain model -----

event(turn_light_on).       % start the fading process
event(switch_fade_out).     % stop fading in and start fading out (dimming)
event(switch_fade_in).      % stop fading out (dimming) and starting fading in
incr_event(switch_fade_out).
incr_event(switch_fade_in).

fluent(brightness(X)).      % range 0-10
fluent(fading_in).
fluent(fading_out).

initiates(turn_light_on, fading_in, T).
releases(turn_light_on, brightness(X), T).

terminates(switch_fade_out, fading_in, T).
initiates(switch_fade_out, fading_out, T).    %//NO_PREPROCESS
can_initiates(switch_fade_out, fading_out, T) :- incr_happens(switch_fade_out, T).

terminates(switch_fade_in, fading_out, T).
initiates(switch_fade_in, fading_in, T).      %//NO_PREPROCESS
can_initiates(switch_fade_in, fading_in, T) :- incr_happens(switch_fade_in, T).


trajectory(fading_in, T1, brightness(NewB), T2) :-
    NewB .=. OldB + ((T2-T1) * 1),
    holdsAt(brightness(OldB), T1).

trajectory(fading_out, T1, brightness(NewB), T2) :-
    NewB .=. OldB - ((T2-T1) * 1),
    holdsAt(brightness(OldB), T1).


happens(switch_fade_out, T) :- !spy,
    holdsAt(brightness(10), T, fading_in).

happens(switch_fade_in, T) :- !spy,
    holdsAt(brightness(0), T, fading_out).


% ----- narrative & queries  -----

max_time(45). % set lower due to the cyclic behavior
initiallyP(brightness(0)).
initiallyN(F) :- not initiallyP(F).

happens(turn_light_on, 10).

?- holdsAt(brightness(X),   10).    % 0

?- happens(switch_fade_out, 20).
?- holdsAt(brightness(X),   20).    % 10

?- happens(switch_fade_in,  30).
?- holdsAt(brightness(X),   30).    % 0

?- happens(switch_fade_out, 40).
?- holdsAt(brightness(X),   40).    % 10

?- happens(switch_fade_out, T).     % 20, 40
?- happens(switch_fade_in,  T).     % 30

% incr_query_max_time(MaxTime).     % can use this based on time in the query


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
