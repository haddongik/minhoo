shader_type canvas_item;

render_mode blend_add, unshaded;

uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.3, 1.0);
uniform float glow_intensity = 3.0;
uniform float glow_radius = 0.2;
uniform float glow_softness = 0.1;

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(SCREEN_UV, center);
    float alpha = smoothstep(glow_radius + glow_softness, glow_radius, dist) * glow_intensity;

    COLOR = vec4(glow_color.rgb, alpha);
    COLOR.a = alpha;
}
