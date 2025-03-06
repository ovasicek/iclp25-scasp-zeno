#include './preprocessed_can_rules/model-fixed-split_holdsAt4-preprocessed.pl'. % include the can_* rules
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

terminates(switch_right, left_filling, T).
initiates(switch_right, left_draining, T).

trajectory(left_filling, T1, water_left(NewW), T2) :-
    TotalFlow .=. 20 - 10, % in rate 20, out rate 10
    NewW .=. OldW + ((T2-T1) * TotalFlow),
    holdsAt(water_left(OldW), T1).

trajectory(left_draining, T1, water_left(NewW), T2) :-
    NewW .=. OldW - ((T2-T1) * 10), % out rate 10
    holdsAt(water_left(OldW), T1).

happens(switch_left, T) :-
    CurrW .=. 50,   % target level
    holdsAt(water_left(CurrW), T, left_draining).
    
duration(1).
happens(switch_left, T) :- !spy,
    CurrW .<. 50,   % target level
    duration(Dur),
    holdsAt(water_left(CurrW), T, left_draining, Dur).


% ----- narrative & queries  -----

initiallyP(water_left(0)).
initiallyN(F) :- not initiallyP(F).

?- holdsAt(water_left(X),       5).     % 0

happens(start(left),            10).
?- holdsAt(water_left(X),       12).    % 20

happens(switch_right,           13).    % switch while below target
?- holdsAt(water_left(X),       13).    % 30

?- holdsAt(left_draining,       T).     % T #> 13,T #=< 14
?- happens(switch_left,         T).     % 14
?- holdsAt(water_left(X),       15).    % 30


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */
