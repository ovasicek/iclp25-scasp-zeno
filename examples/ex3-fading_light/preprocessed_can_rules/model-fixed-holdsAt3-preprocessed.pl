
can_initiates(fade_in_end, brightness(10)).
can_initiates(turn_light_on, fading_in).
can_releases(turn_light_on, brightness(X)).
can_terminates(fade_in_end, brightness(X)).
can_terminates(fade_in_end, fading_in).
can_trajectory(fading_in, T1, brightness(NewI), T2).
