shader_type canvas_item;

uniform float flicker_speed : hint_range(0.1, 10.0) = 2.0;
uniform float flicker_intensity : hint_range(0.0, 1.0) = 0.2;

void light() {
    // Generate a smooth flickering effect using sine waves
    float time_factor = TIME * flicker_speed;
    float flicker = sin(time_factor) * flicker_intensity;

    // Apply the flicker effect by modulating the final light output
    LIGHT *= (0.5 + flicker);
}