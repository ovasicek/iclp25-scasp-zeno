
can_initiates(full_brightness_reached, light_intensity(10)).
can_initiates(turn_light_on, fading_in).
can_releases(turn_light_on, light_intensity(X)).
can_terminates(full_brightness_reached, fading_in).
can_terminates(full_brightness_reached, light_intensity(X)).
can_trajectory(fading_in, T1, light_intensity(NewI), T2).
