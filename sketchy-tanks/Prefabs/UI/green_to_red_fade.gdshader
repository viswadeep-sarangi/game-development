shader_type canvas_item;

uniform float time : hint_range(0, 1.0)=0.5;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Calculate the tint based on time
    float t = 0.5 * (1.0 + sin(TIME * time * 3.14159));
    vec3 tint_color = mix(vec3(0.5, 1.0, 0.5), vec3(1.0, 0.5, 0.5), t);

    // Apply the tint to the texture
    COLOR = vec4(tex_color.rgb * tint_color, tex_color.a);
}
