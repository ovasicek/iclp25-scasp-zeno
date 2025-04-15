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
incr_event(switch_left).
incr_event(switch_right).

initiates(start(left), left_filling, T).
initiates(start(right), right_filling, T).
releases(start(_), water_left(X), T).
releases(start(_), water_right(X), T).

initiates(switch_left, left_filling, T).
can_initiates(switch_left, left_filling, T) :- incr_happens(switch_left, T).
terminates(switch_left, right_filling, T).

terminates(switch_right, left_filling, T).
initiates(switch_right, right_filling, T).
can_initiates(switch_right, right_filling, T) :- incr_happens(switch_right, T).

trajectory(left_filling, T1, water_left(NewW), T2) :-
    TotalFlow .=. 20 - 10, % in rate 20, out rate 10
    NewW .=. OldW + ((T2-T1) * TotalFlow),
    holdsAt(water_left(OldW), T1).

trajectory(right_filling, T1, water_left(NewW), T2) :-
    NewW .=. OldW - ((T2-T1) * 10), % out rate 10
    holdsAt(water_left(OldW), T1).

trajectory(right_filling, T1, water_right(NewW), T2) :-
    TotalFlow .=. 20 - 10, % in rate 20, out rate 10
    NewW .=. OldW + ((T2-T1) * TotalFlow),
    holdsAt(water_right(OldW), T1).

trajectory(left_filling, T1, water_right(NewW), T2) :-
    NewW .=. OldW - ((T2-T1) * 10), % out rate 10
    holdsAt(water_right(OldW), T1).

happens(switch_left, T) :- !spy,
    CurrW .=. 50,   % target level
    holdsAt(water_left(CurrW), T, right_filling).

happens(switch_right, T) :- !spy,
    CurrW .=. 50,   % target level
    holdsAt(water_right(CurrW), T, left_filling).


% ----- narrative & queries  -----

initiallyP(water_left(100)).
initiallyP(water_right(50)).
initiallyN(F) :- not initiallyP(F).

happens(start(right),               10).

?- !incr_max_time(30), T .=<. 30, happens(switch_left,  T).   % 15, 25
?- !incr_max_time(30), T .=<. 30, happens(switch_right, T).   % 20, 30


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */