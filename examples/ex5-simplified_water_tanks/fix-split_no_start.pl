% problems:
%   repeated trigger          - no longer present (trajectory does not start)
%   self-end trajectory       - fixed via holdsAt/3 (or holdsAt/4)
%   trajectory end at ineq.   - fixed via remodelling (trajectory does not start)

#include './preprocessed_can_rules/fix-split_no_start-preprocessed.pl'. % include the can_* rules
#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).                      % it is useful to have an upper bound on time for the full axioms


% ----- domain model -----

fluent(water_left(X)).
fluent(left_filling).
fluent(left_draining).

event(start(left)).
event(start(right)).
event(switch_left).
event(switch_right).

initiates(start(left), left_filling, T).
initiates(start(right), left_draining, T).
releases(start(_), water_left(X), T).

initiates(switch_left, left_filling, T).
terminates(switch_left, left_draining, T).

terminates(switch_right, left_filling, T) :-
    X .>. 50, % > target level
    holdsAt(water_left(X), T, left_filling).
initiates(switch_right, left_draining, T) :-
    X .>. 50, % > target level
    holdsAt(water_left(X), T, left_filling).

trajectory(left_filling, T1, water_left(NewW), T2) :-
    TotalFlow .=. 30 - 20, % in rate 30, out rate 20
    NewW .=. OldW + ((T2-T1) * TotalFlow),
    holdsAt(water_left(OldW), T1).

trajectory(left_draining, T1, water_left(NewW), T2) :-
    NewW .=. OldW - ((T2-T1) * 20), % out rate 20
    holdsAt(water_left(OldW), T1).

happens(switch_left, T) :- !spy,
    CurrW .=<. 50,   % target level
    holdsAt(water_left(CurrW), T, left_draining).
    

% ----- narrative & queries  -----
% based on narrative 2

initiallyP(water_left(0)).
initiallyN(F) :- not initiallyP(F).

happens(start(left),        10).

happens(switch_right,       13).    % switch while below target
?- holdsAt(water_left(X),   13).    % 30

?- holdsAt(left_draining,   T).     % no models
?- happens(switch_left,     T).     % no models
?- holdsAt(water_left(X),   15).    % 50


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
