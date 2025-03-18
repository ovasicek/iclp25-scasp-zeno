
can_initiates(start(left), left_filling, T).
can_initiates(start(right), right_filling, T).
can_initiates(switch_left, left_filling, T).
can_initiates(switch_right, right_filling, T).
can_releases(start(_), water_left(X), T).
can_releases(start(_), water_right(X), T).
can_terminates(switch_left, right_filling, T).
can_terminates(switch_right, left_filling, T).  
can_trajectory(left_filling, T1, water_left(NewW), T2).
can_trajectory(left_filling, T1, water_right(NewW), T2).
can_trajectory(right_filling, T1, water_left(NewW), T2).
can_trajectory(right_filling, T1, water_right(NewW), T2).
