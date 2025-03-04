
can_initiates(switch_fade_in, fading_in, T).
can_initiates(switch_fade_out, fading_out, T).
can_initiates(turn_light_on, fading_in, T).
can_releases(turn_light_on, brightness(X), T).
can_terminates(switch_fade_in, fading_out, T).
can_terminates(switch_fade_out, fading_in, T).
can_trajectory(fading_in, T1, brightness(NewB), T2).
can_trajectory(fading_out, T1, brightness(NewB), T2).
