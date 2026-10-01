shader_type canvas_item;
render_mode blend_add;

// Crackling lightning bolts that converge from the outer edge of the quad onto a
// ball sitting in the middle. Bolt layout re-rolls `flicker_rate` times per second.

uniform float intensity : hint_range(0.0, 3.0) = 1.0;
uniform int bolt_count : hint_range(1, 12) = 6;
uniform float flicker_rate = 18.0;
uniform float inner_radius : hint_range(0.0, 1.0) = 0.34;
uniform float jitter = 0.35;
uniform float thickness = 0.012;
uniform vec4 core_color : source_color = vec4(0.92, 0.97, 1.0, 1.0);
uniform vec4 glow_color : source_color = vec4(0.3, 0.7, 1.0, 1.0);

float hash11(float x) {
	return fract(sin(x * 127.1) * 43758.5453);
}

float noise1(float x) {
	float i = floor(x);
	float f = fract(x);
	float u = f * f * (3.0 - 2.0 * f);
	return mix(hash11(i), hash11(i + 1.0), u);
}

void fragment() {
	vec2 p = UV * 2.0 - 1.0;
	float r = length(p);
	float a = atan(p.y, p.x);
	float frame = mod(floor(TIME * flicker_rate), 1000.0);

	// Bolts only exist between the ball's surface and the edge of the quad.
	float along = smoothstep(inner_radius - 0.04, inner_radius + 0.04, r) * (1.0 - smoothstep(0.85, 1.0, r));

	float light = 0.0;
	for (int i = 0; i < 12; i++) {
		if (i >= bolt_count) {
			break;
		}
		float fi = float(i);
		// Spread bolt roots around the ring, nudged randomly each flicker.
		float base = (fi + hash11(fi * 13.7 + frame) * 0.8) / float(bolt_count) * TAU;
		// Jagged path: the bolt's angle wobbles with distance from the centre.
		float wobble = (noise1(r * 9.0 + fi * 7.3 + frame * 3.1) - 0.5) * 2.0 * jitter
			+ (noise1(r * 27.0 + fi * 3.7 + frame * 5.9) - 0.5) * jitter * 0.5;
		float da = mod(a - (base + wobble) + PI, TAU) - PI;
		float d = abs(da) * r;
		float core = 1.0 - smoothstep(0.0, thickness, d);
		float glow = exp(-d / (thickness * 3.0)) * 0.5;
		light += (core + glow) * along;
	}

	// Charged halo hugging the ball the bolts are feeding.
	light += exp(-abs(r - inner_radius) * 14.0) * 0.6 * (1.0 - smoothstep(0.9, 1.0, r));

	light *= intensity;
	vec3 col = mix(glow_color.rgb, core_color.rgb, clamp(light - 0.6, 0.0, 1.0));
	COLOR = vec4(col * light, clamp(light, 0.0, 1.0));
}
