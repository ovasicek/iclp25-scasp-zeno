
can_initiates(switch_fade_in, fading_in, T).
can_initiates(switch_fade_out, fading_out, T).
can_initiates(turn_light_off, light_intensity(0), T).
can_initiates(turn_light_on, fading_in, T).
can_initiates(turn_light_on, light_on, T).
can_releases(turn_light_on, brightness(X), T).
can_terminates(switch_fade_in, fading_out, T).
can_terminates(switch_fade_out, fading_in, T).
can_terminates(turn_light_off, fading_in, T).
can_terminates(turn_light_off, fading_out, T).
can_terminates(turn_light_off, light_intensity(X), T).
can_terminates(turn_light_off, light_on, T).
can_trajectory(fading_in, T1, brightness(NewLevel), T2).
can_trajectory(fading_out, T1, brightness(NewLevel), T2).
