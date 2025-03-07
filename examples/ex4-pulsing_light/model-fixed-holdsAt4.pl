% problems
%   self-end trajectory - fixed via holdsAt/3 (or holdsAt/4)
%   circular trajectory - fixed via pre-advertising minimum duration

#include './preprocessed_can_rules/model-fixed-holdsAt4-preprocessed.pl'. % include the can_* rules
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
event(fade_in_end).         % stop fading in and start fading out (dimming)
event(fade_out_end).        % stop fading out (dimming) and starting fading in

fluent(brightness(X)).      % range 0-10
fluent(fading_in).
fluent(fading_out).

initiates(turn_light_on, fading_in, T).
releases(turn_light_on, brightness(X), T).

terminates(fade_in_end, fading_in, T).
initiates(fade_in_end, fading_out, T).

terminates(fade_out_end, fading_out, T).
initiates(fade_out_end, fading_in, T).

trajectory(fading_in, T1, brightness(NewB), T2) :-
    NewB .=. OldB + ((T2-T1) * 1),
    holdsAt(brightness(OldB), T1).

trajectory(fading_out, T1, brightness(NewB), T2) :-
    NewB .=. OldB - ((T2-T1) * 1),
    holdsAt(brightness(OldB), T1).

duration(10).
happens(fade_in_end, T) :- !spy,
    duration(Dur),
    holdsAt(brightness(10), T, fading_in, Dur).

happens(fade_out_end, T) :- !spy,
    duration(Dur),
    holdsAt(brightness(0), T, fading_out, Dur).


% ----- narrative & queries  -----

initiallyP(brightness(0)).
initiallyN(F) :- not initiallyP(F).

happens(turn_light_on,      10).

?- holdsAt(brightness(X),   10).    % 0

?- happens(fade_in_end,     20).
?- holdsAt(brightness(X),   20).    % 10

?- happens(fade_out_end,    30).
?- holdsAt(brightness(X),   30).    % 0

?- happens(fade_in_end,     40).
?- holdsAt(brightness(X),   40).    % 10

?- T .=<. 45, happens(fade_in_end,  T). % 20, 40
?- T .=<. 45, happens(fade_out_end, T). % 30


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
