shader_type spatial;

uniform sampler2D albedo_texture: source_color;
uniform sampler2D curve;
varying float lifetime;

void vertex() {
	lifetime = INSTANCE_CUSTOM.y;
}

void fragment() {
	vec4 tex = texture(albedo_texture, UV);
	vec4 curve_tex = texture(curve, vec2(lifetime,0));
    ALBEDO = tex.rgb;
    ALPHA = tex.a * curve_tex.r;
	EMISSION = ALBEDO;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
