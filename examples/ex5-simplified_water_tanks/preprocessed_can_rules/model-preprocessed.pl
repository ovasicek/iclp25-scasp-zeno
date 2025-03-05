
can_initiates(start(left), left_filling, T).
can_initiates(start(right), left_draining, T).
can_initiates(switch_left, left_filling, T).
can_initiates(switch_right, left_draining, T).
can_releases(start(_), water_left(X), T).
can_terminates(switch_left, left_draining, T).
can_terminates(switch_right, left_filling, T).
can_trajectory(left_draining, T1, water_left(NewLevel), T2).
can_trajectory(left_filling, T1, water_left(NewLevel), T2).
