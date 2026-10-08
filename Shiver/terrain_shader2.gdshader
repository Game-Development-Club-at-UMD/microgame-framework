shader_type spatial;

uniform sampler2D noise;
uniform float height_mult;
uniform sampler2D albedo_texture: repeat_enable,filter_nearest,source_color;

void vertex() {
	float height = texture(noise, UV).x * height_mult;
	VERTEX.y += height;
}

void fragment() {
	vec2 size = vec2(32,32);
	vec4 tex = texture(albedo_texture, UV * size);
    ALBEDO = tex.rgb;
    //ALPHA = tex.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
