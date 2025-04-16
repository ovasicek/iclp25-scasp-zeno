#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).                      % it is useful to have an upper bound on time for the full axioms


% ----- domain model -----

% fluents
fluent(height(X)).
fluent(velocity(X)).

fluent(falling).
fluent(rising).

fluent(constant_fall_rate(X)).        % simplified to a constant fall rate instead of accelerating over time

% input events
event(drop).
event(catch).

% triggered events
event(fall_down).
event(hit_ground).
event(bounce_up).
event(reach_apex).


% start by dropping the ball
releases(drop, height(X), T).
releases(drop, velocity(X), T).

% start by dropping the ball
initiates(fall_down, falling, T).

% stop falling when hitting the ground
terminates(hit_ground, falling, T).

% bounce back up
initiates(bounce_up, rising, T).

% stop rising when reaching the apex
terminates(reach_apex, rising, T).

% stop everything by catching the ball
terminates(catch, falling, T).
terminates(catch, rising, T).

initiates(catch, height(X), T) :- holdsAt(height(X), T).
terminates(catch, height(X), T) :- X .<>. Y, holdsAt(height(Y), T).

initiates(catch, velocity(0), T).
terminates(catch, velocity(X), T) :- X .<>. 0.


% falling 
trajectory(falling, T1, height(XatT2), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    XatT2 .=. XatT1 - ((T2-T1) * Rate),
    holdsAt(height(XatT1), T1).

trajectory(falling, T1, velocity(XatT2), T2) :-
    initiallyP(constant_fall_rate(FallRate)),
    XatT2 .=. XatT1 + ((T2-T1) * FallRate),
    holdsAt(velocity(XatT1), T1).


% rising
trajectory(rising, T1, height(XatT2), T2) :-
    initiallyP(constant_fall_rate(Rate)),
    XatT2 .=. XatT1 + ((T2-T1) * Rate),
    holdsAt(height(XatT1), T1).

trajectory(rising, T1, velocity(XatT2), T2) :-
    initiallyP(constant_fall_rate(FallRate)),
    XatT2 .=. XatT1 - ((T2-T1) * FallRate),
    holdsAt(velocity(XatT1), T1).


happens(fall_down, T) :- happens(drop, T).

duration(D) :- initiallyP(height(X)), initiallyP(constant_fall_rate(R)), D .=. X / R.
happens(hit_ground, T) :- !spy, duration(D), holdsAt(height(0), T, falling, D).
happens(bounce_up, T) :- happens(hit_ground, T).

happens(reach_apex, T) :- !spy, duration(D), holdsAt(velocity(0), T, rising, D).
happens(fall_down, T) :- happens(reach_apex, T).


% ----- narrative & queries  -----

initiallyP(height(10)).
initiallyP(velocity(0)).
initiallyP(constant_fall_rate(1)).

initiallyN(F) :- not initiallyP(F).

happens(drop,                           10).

?- happens(hit_ground,                  T).     % 20, 40, 60, 80, 100 (max_time 100)


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */