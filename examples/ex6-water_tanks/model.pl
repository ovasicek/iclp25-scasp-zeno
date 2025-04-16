% problems:
%   repeated trigger          - manifests in the "trajectory end at ineq." problem
%   self-end trajectory       - fixed via holdsAt/3 (or holdsAt/4)
%   circular trajectories     - needs to be fixed 
%   trajectory end at ineq.   - needs to be fixed
%   traditional zeno behavior - needs to be fixed

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
fluent(water_right(X)).
fluent(left_filling).
fluent(right_filling).  % replaced left_draining

event(start(left)).
event(start(right)).
event(switch_left).
event(switch_right).

initiates(start(left), left_filling, T).
initiates(start(right), right_filling, T).
releases(start(_), water_left(X), T).
releases(start(_), water_right(X), T).

initiates(switch_left, left_filling, T).
terminates(switch_left, right_filling, T).

terminates(switch_right, left_filling, T).
initiates(switch_right, right_filling, T).

trajectory(left_filling, T1, water_left(NewW), T2) :-
    TotalFlow .=. 30 - 20, % in rate 30, out rate 20
    NewW .=. OldW + ((T2-T1) * TotalFlow),
    holdsAt(water_left(OldW), T1).

trajectory(right_filling, T1, water_left(NewW), T2) :-
    NewW .=. OldW - ((T2-T1) * 20), % out rate 20
    holdsAt(water_left(OldW), T1).

trajectory(right_filling, T1, water_right(NewW), T2) :-
    TotalFlow .=. 30 - 20, % in rate 30, out rate 20
    NewW .=. OldW + ((T2-T1) * TotalFlow),
    holdsAt(water_right(OldW), T1).

trajectory(left_filling, T1, water_right(NewW), T2) :-
    NewW .=. OldW - ((T2-T1) * 20), % out rate 20
    holdsAt(water_right(OldW), T1).

happens(switch_left, T) :- !spy,
    CurrW .=<. 50,   % target level
    holdsAt(water_left(CurrW), T, right_filling).

happens(switch_right, T) :- !spy,
    CurrW .=<. 50,   % target level
    holdsAt(water_right(CurrW), T, left_filling).


% ----- narrative & queries  -----

initiallyP(water_left(100)).
initiallyP(water_right(100)).
initiallyN(F) :- not initiallyP(F).

happens(start(right),           10).

?- happens(switch_left,         25/2).%(12.5)       % non-term., should be yes
?- holdsAt(water_left(X),       25/2).%(12.5)       % non-term., should be 50
?- holdsAt(water_right(X),      25/2).%(12.5)       % non-term., should be 125

?- happens(switch_right,        65/4).%(16.25)      % non-term., should be yes
?- holdsAt(water_left(X),       65/4).%(16.25)      % non-term., should be 87.5 (175/2)
?- holdsAt(water_right(X),      65/4).%(16.25)      % non-term., should be 50

?- happens(switch_left,         145/8).%(18.125)    % non-term., should be yes
?- holdsAt(water_left(X),       145/8).%(18.125)    % non-term., should be 50
?- holdsAt(water_right(X),      145/8).%(18.125)    % non-term., should be 68.75 (275/4)

?- happens(switch_right,        305/16).%(19.0625)  % non-term., should be yes
?- holdsAt(water_left(X),       305/16).%(19.0625)  % non-term., should be 59.375 (475/8)
?- holdsAt(water_right(X),      305/16).%(19.0625)  % non-term., should be 50

?- happens(switch_left,         625/32).%(19.53125) % non-term., should be yes
?- holdsAt(water_left(X),       625/32).%(19.53125) % non-term., should be 50
?- holdsAt(water_right(X),      625/32).%(19.53125) % non-term., should be 54.6875 (875/16)

?- T .=<. 19.5, happens(switch_left,  T).           % non-term., should be % 25/2 (12.5), 145/8 (18.125)
?- T .=<. 19.5, happens(switch_right, T).           % non-term., should be 65/4 (16.25), 305/16 (19.0625)
?- holdsAt(water_right(X),      19.5).              % non-term., should be 435/8 (54.375)
?- holdsAt(water_left(X),       19.5).              % non-term., should be 405/8 (50.625)

/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */