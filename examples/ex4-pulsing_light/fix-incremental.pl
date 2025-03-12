% problems
%   self-end trajectory - fixed via holdsAt/3 (or holdsAt/4)
%   circular trajectory - fixed via incremental (forward) reasoning

#include './preprocessed_can_rules/fix-incremental-preprocessed.pl'. % include the can_* rules
#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).                      % it is useful to have an upper bound on time for the full axioms


% ----- domain model -----

event(turn_light_on).       % start the fading process
event(turn_light_off).
event(fade_in_end).         % stop fading in and start fading out (dimming)
event(fade_out_end).        % stop fading out (dimming) and starting fading in
incr_event(fade_in_end).
incr_event(fade_out_end).

fluent(light_on).
fluent(brightness(X)).      % range 0-10
fluent(fading_in).
fluent(fading_out).

initiates(turn_light_on,  light_on, T).
initiates(turn_light_on, fading_in, T).
releases(turn_light_on, brightness(X), T).

terminates(turn_light_off, light_on, T).
terminates(turn_light_off, fading_in, T) :- holdsAt(fading_in, T).
terminates(turn_light_off, fading_out, T) :- holdsAt(fading_out, T).
initiates(turn_light_off, brightness(0), T).
terminates(turn_light_off, brightness(X), T) :- X .<>. 0.

terminates(fade_in_end, fading_in, T).
initiates(fade_in_end, fading_out, T).    %//NO_PREPROCESS
can_initiates(fade_in_end, fading_out, T) :- incr_happens(fade_in_end, T).

terminates(fade_out_end, fading_out, T).
initiates(fade_out_end, fading_in, T).      %//NO_PREPROCESS
can_initiates(fade_out_end, fading_in, T) :- incr_happens(fade_out_end, T).

trajectory(fading_in, T1, brightness(NewB), T2) :-
    NewB .=. OldB + ((T2-T1) * 1),
    holdsAt(brightness(OldB), T1).

trajectory(fading_out, T1, brightness(NewB), T2) :-
    NewB .=. OldB - ((T2-T1) * 1),
    holdsAt(brightness(OldB), T1).

happens(fade_in_end, T) :- !spy,
    holdsAt(brightness(10), T, fading_in).

happens(fade_out_end, T) :- !spy,
    holdsAt(brightness(0), T, fading_out).


% ----- narrative & queries  -----

initiallyP(brightness(0)).
%initiallyN(light_on).
initiallyN(F) :- not initiallyP(F).

happens(turn_light_on,      10).
happens(turn_light_off,     45).

?- holdsAt(brightness(X),   10).    % 0

?- happens(fade_in_end,     20).
?- holdsAt(brightness(X),   20).    % 10

?- happens(fade_out_end,    30).
?- holdsAt(brightness(X),   30).    % 0

?- happens(fade_in_end,     40).
?- holdsAt(brightness(X),   40).    % 10

?- happens(fade_in_end,     T).     % 20, 40
?- happens(fade_out_end,    T).     % 30

% incr_query_max_time(45).          % can use this based on time in the query

/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
