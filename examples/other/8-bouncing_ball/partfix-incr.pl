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
fluent(velocity_loss_portion(X)).     % ball looses a portion of velocity on each bounce

% input events
event(drop).
event(catch).

% triggered events
event(fall_down).
event(hit_ground).
event(bounce_up).
event(reach_apex).
event(stop_bouncing).


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

% stop everything if the ball stops bouncing
initiates(stop_bouncing, height(0), T).
terminates(stop_bouncing, height(X), T) :- X .<>. 0.

initiates(stop_bouncing, velocity(0), T).
terminates(stop_bouncing, velocity(X), T) :- X .<>. 0.


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
    initiallyP(velocity_loss_portion(LossPortion)),
    StartVelocity .=. XatT1*(1-LossPortion),
    XatT2 .=. StartVelocity - ((T2-T1) * FallRate),
    holdsAt(velocity(XatT1), T1).


incr_event(hit_ground).
incr_event(reach_apex).

happens(fall_down, T) :- happens(drop, T).

happens(hit_ground, T) :- !spy, holdsAt(height(0), T, falling).
happens(bounce_up, T) :- incr_happens(hit_ground, T), X .>. 0, holdsAt(velocity(X), T, falling).
happens(stop_bouncing, T) :- incr_happens(hit_ground, T), holdsAt(velocity(0), T, falling).

happens(reach_apex, T) :- !spy, holdsAt(velocity(0), T, rising).
happens(fall_down, T) :- incr_happens(reach_apex, T).


% ----- narrative & queries  -----

initiallyP(height(10)).
initiallyP(velocity(0)).
initiallyP(constant_fall_rate(1)).
initiallyP(velocity_loss_portion(0.75)).

initiallyN(F) :- not initiallyP(F).

happens(drop,                           10).

?- !incr_max_time(25),
   happens(hit_ground,                  T).     % 20, 25, 26.25, 26.40625
   
happens(catch,                          26).
    ?- holdsAt(height(X),               30).    % 0.25
    ?- holdsAt(velocity(X),             30).    % 0

?- happens(hit_ground,                  T).     % 20, 25


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */