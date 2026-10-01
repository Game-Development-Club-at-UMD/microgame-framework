shader_type canvas_item;

// Full-screen procedural explosion: white-hot flash, a billowing fireball that
// swallows the whole screen while cooling from yellow to red to smoke, a shockwave
// ring, and a choking smoke cloud left behind.
// Animate `progress` from 0.0 to 1.0 (the Explosion scene's AnimationPlayer does this).
// Meant for a full-rect ColorRect; explosion.gd sets center/aspect/reach.

uniform float progress : hint_range(0.0, 1.0) = 0.0;
// Blast origin in UV space (0..1 across the screen).
uniform vec2 center = vec2(0.5, 0.5);
// Screen width / height, so the blast stays round.
uniform float aspect = 1.7778;
// Distance (in screen heights) from the origin to the farthest screen corner.
uniform float reach = 1.0;
uniform float noise_seed = 0.0;
uniform float noise_scale = 5.0;
uniform vec4 core_color : source_color = vec4(1.0, 0.97, 0.82, 1.0);
uniform vec4 flame_color : source_color = vec4(1.0, 0.6, 0.12, 1.0);
uniform vec4 ember_color : source_color = vec4(0.85, 0.16, 0.05, 1.0);
uniform vec4 smoke_color : source_color = vec4(0.16, 0.13, 0.12, 1.0);
uniform vec4 shockwave_color : source_color = vec4(1.0, 0.9, 0.7, 1.0);

float hash(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

float value_noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	vec2 u = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float fbm(vec2 p) {
	float total = 0.0;
	float amp = 0.5;
	for (int i = 0; i < 5; i++) {
		total += value_noise(p) * amp;
		p = p * 2.03 + vec2(17.1, 9.2);
		amp *= 0.5;
	}
	return total;
}

// 0 = cold smoke, 1 = white-hot core.
vec3 heat_ramp(float h) {
	vec3 col = mix(smoke_color.rgb, ember_color.rgb, smoothstep(0.0, 0.35, h));
	col = mix(col, flame_color.rgb, smoothstep(0.3, 0.65, h));
	col = mix(col, core_color.rgb, smoothstep(0.65, 0.95, h));
	return col;
}

void fragment() {
	// r = 1.0 is the farthest corner of the screen from the blast.
	vec2 p = (UV - center) * vec2(aspect, 1.0) / max(reach, 0.001);
	float r = length(p);
	float t = clamp(progress, 0.0, 1.0);

	// Fireball expands fast, then slows down. Its smallest edge ends up past
	// r = 1.0, so every pixel on screen gets engulfed.
	float grow = 1.0 - pow(1.0 - t, 3.0);
	float radius = mix(0.03, 1.6, grow);

	// Billowing turbulence that rolls outward over time.
	vec2 dir = p / max(r, 0.0001);
	float n = fbm(p * noise_scale - dir * t * 3.0 + noise_seed);
	float edge = radius * (0.7 + 0.6 * n);
	float body = 1.0 - smoothstep(edge * 0.85, edge, r);

	// Hottest in the middle, cooling as the blast ages.
	float heat = (1.0 - r / max(edge, 0.001)) * 1.2 + (n - 0.5) * 0.6 + 0.5 - t * 1.3;
	heat = clamp(heat, 0.0, 1.0);

	// Late in the blast the cloud thins out a little, but thick smoke stays on screen.
	float dissolve = smoothstep(0.45, 1.0, t) * 0.55;
	float holes = fbm(p * noise_scale * 1.7 + noise_seed * 1.3 + t);
	body *= smoothstep(dissolve - 0.05, dissolve + 0.1, holes + (1.0 - t) * 0.2);

	vec3 col = heat_ramp(heat);
	float alpha = body * mix(0.85, 1.0, smoothstep(0.0, 0.3, heat));

	// Shockwave ring racing out ahead of the fireball.
	float ring_r = mix(0.05, 1.3, sqrt(t));
	float ring_w = mix(0.02, 0.06, t);
	float ring = 1.0 - smoothstep(0.0, ring_w, abs(r - ring_r));
	ring *= (1.0 - smoothstep(0.0, 0.6, t)) * 0.8;
	col = mix(col, shockwave_color.rgb, ring * (1.0 - alpha * 0.5));
	alpha = max(alpha, ring);

	// Blinding flash right at detonation.
	float flash = (1.0 - smoothstep(0.0, 0.12, t)) * (1.0 - smoothstep(0.0, 0.6 + t * 4.0, r));
	col = mix(col, core_color.rgb, flash);
	alpha = max(alpha, flash);

	COLOR = vec4(col, alpha);
}
