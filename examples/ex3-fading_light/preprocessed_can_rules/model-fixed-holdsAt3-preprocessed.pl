
can_initiates(fade_in_end, brightness(10), T).
can_initiates(turn_light_on, fading_in, T).
can_releases(turn_light_on, brightness(X), T).
can_terminates(fade_in_end, brightness(X), T).
can_terminates(fade_in_end, fading_in, T).
can_trajectory(fading_in, T1, brightness(NewB), T2).
