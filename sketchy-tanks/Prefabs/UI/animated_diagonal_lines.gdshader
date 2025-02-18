shader_type canvas_item;

uniform float speed : hint_range(0.0, 0.5) = 0.05
;

void fragment() {
    // Calculate the diagonal pattern with time-based movement
    float angle = 60.0; // degrees
    float stripe_width = 0.33; // Adjust for thicker or thinner lines
    vec2 uv = UV;
    uv.y -= TIME * speed;

    // Rotate UVs to create diagonal lines
    float rotated = uv.x + uv.y;
    float stripes = step(0.5, fract(rotated / stripe_width));

    // Alternate between black and white stripes
    COLOR = vec4(vec3(stripes), 1.0);
}
