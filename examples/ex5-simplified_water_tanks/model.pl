% problems:
%   repeated trigger          - manifests in the "trajectory end at ineq." problem
%   self-end trajectory       - fixed via holdsAt/3 (or holdsAt/4)
%   trajectory end at ineq.   - needs to be fixed in narrative 2

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

trajectory(left_draining, T1, water_left(NewW), T2) :-
    NewW .=. OldW - ((T2-T1) * 20), % out rate 20
    holdsAt(water_left(OldW), T1).

trajectory(left_filling, T1, water_left(NewW), T2) :-
    TotalFlow .=. 30 - 20, % in rate 30, out rate 20
    NewW .=. OldW + ((T2-T1) * TotalFlow),
    holdsAt(water_left(OldW), T1).

happens(switch_left, T) :- !spy,
    CurrW .=<. 50,   % target level
    holdsAt(water_left(CurrW), T, left_draining).
    

% ----- narrative & queries  -----

% in separate files...
