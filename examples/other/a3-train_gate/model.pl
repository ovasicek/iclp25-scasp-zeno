#show happens/2, not_happens/2.
#show holdsAt/2, not_holdsAt/2.
#show initiallyP/1, initiallyN/1.
#show stoppedIn/3, not_stoppedIn/3.
#show startedIn/3, not_startedIn/3.
#show initiates/3, terminates/3, releases/3.
#show trajectory/4.

max_time(100).


% ----- domain model -----

% input event
event(start).

% triggered events
event(signal_train_entered).
event(signal_gate_start_lowering).
event(signal_gate_closed).
event(signal_train_exited).
event(signal_gate_start_raising).
event(signal_gate_open).

% train fluents
fluent(train_moving).
fluent(train_position(X)).
fluent(train_is_passing_through).
fluent(train_is_past_the_gate).

% gate fluents
fluent(gate_angle(X)).
fluent(gate_is_lowering).
fluent(gate_is_rising).
fluent(gate_is_open).
fluent(gate_is_closed).


% event effects
initiates(start, train_moving, T).
releases(start, train_position(X), T).

initiates(signal_train_entered, train_is_passing_through, T).

initiates(signal_gate_start_lowering, gate_is_lowering, T).
terminates(signal_gate_start_lowering, gate_is_open, T).
releases(signal_gate_start_lowering, gate_angle(_), T).

initiates(signal_gate_closed, gate_is_closed, T).
terminates(signal_gate_closed, gate_is_lowering, T).
initiates(signal_gate_closed, gate_angle(90), T).
terminates(signal_gate_closed, gate_angle(X), T) :- X .<>. 90.

initiates(signal_train_exited, train_is_past_the_gate, T).
terminates(signal_train_exited, train_is_passing_through, T).

initiates(signal_gate_start_raising, gate_is_rising, T).
terminates(signal_gate_start_raising, gate_is_closed, T).
releases(signal_gate_start_raising, gate_angle(_), T).
terminates(signal_gate_start_raising, gate_is_lowering, T) :- holdsAt(gate_is_lowering, T).     % in case signal to start raising happens before the gate fully closes


initiates(signal_gate_open, gate_is_open, T).
terminates(signal_gate_open, gate_is_rising, T).
initiates(signal_gate_open, gate_angle(0), T).
terminates(signal_gate_open, gate_angle(X), T) :- X .<>. 0.


% event triggers
happens(signal_train_entered, T) :- holdsAt(train_position(10), T).
happens(signal_train_exited, T) :- holdsAt(train_position(20), T).

happens(signal_gate_start_lowering, T) :- holdsAt(train_position(5), T).
happens(signal_gate_closed, T) :-!spy, holdsAt(gate_angle(90), T).

happens(signal_gate_start_raising, T) :- happens(signal_train_exited, T).
happens(signal_gate_open, T) :- !spy, holdsAt(gate_angle(0), T).


% trajectories
trajectory(train_moving, T1, train_position(CurPos), T2) :- 
    train_speed(Speed),
    CurPos .=. StartPos + (( T2 - T1 ) * Speed),
    holdsAt(train_position(StartPos), T1).

trajectory(gate_is_lowering, T1, gate_angle(CurAngl), T2) :-
    CurAngl .>=. 0, CurAngl .=<. 90,
    angle_lower_rate(Rate),
    CurAngl .=. StartAngl + (( T2 - T1 ) * Rate),
    holdsAt(gate_angle(StartAngl), T1).

trajectory(gate_is_rising, T1, gate_angle(CurAngl), T2) :-
    CurAngl .>=. 0, CurAngl .=<. 90,
    angle_rise_rate(Rate),
    CurAngl .=. StartAngl - (( T2 - T1 ) * Rate),
    holdsAt(gate_angle(StartAngl), T1).


% ----- narrative & queries  -----

train_speed(1).
angle_lower_rate(30).
angle_rise_rate(40).

initiallyP(gate_is_open).
initiallyP(train_position(0)).
initiallyP(gate_angle(0)).
initiallyN(F) :- not initiallyP(F).
happens(start, 1).


?- happens(signal_train_entered, T).        % 11
?- happens(signal_train_exited, T).         % 21
?- holdsAt(train_is_passing_through, T).    % 11 < T =< 21

?- holdsAt(train_is_passing_through, T), holdsAt(gate_is_open, T).          % no
?- holdsAt(gate_is_closed, T1), T2 .>. T1, holdsAt(gate_is_open, T2).       % 9 < T1 =< 21; 93/4 < T2 < 1000

unsafe :- holdsAt(train_is_passing_through, T), holdsAt(gate_is_rising, T).
unsafe :- holdsAt(train_is_passing_through, T), holdsAt(gate_is_open, T).
unsafe :- holdsAt(train_is_passing_through, T), holdsAt(gate_is_lowering, T).
?- unsafe.  % no

unsafe2 :- holdsAt(train_is_passing_through, T), not_holdsAt(gate_is_closed, T).
?- unsafe2. % no

safe :- not unsafe.
?- safe.    % yes

liveness_threshold(30).
live :-
    liveness_threshold(Thresh), T1 .>. T, T1 .<. T + Thresh,
    holdsAt(train_is_passing_through, T), holdsAt(gate_is_closed, T),
    holdsAt(gate_is_open, T1).
?- live.    % yes


?- holdsAt(train_position(X), 5).   % 4
?- holdsAt(gate_angle(X), 5).       % 0
?- happens(E, T).
    % start,                        1
    % signal_gate_start_lowering,   6
    % signal_gate_closed,           9
    % signal_train_entered,         11
    % signal_train_exited,          21
    % signal_gate_start_raising,    21
    % signal_gate_open,             93/4 (23,25)


/* ----------------- MOVE THIS UP AND DOWN TO CHANGE QUERY ----------------- -/

/* ------------------------------ end of file ------------------------------ */