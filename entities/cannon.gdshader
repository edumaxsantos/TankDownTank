shader_type canvas_item;

uniform bool apply_white;
uniform float whiteness_amount : hint_range(0.0, 1.0) = 0.5;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 tex_color = texture(TEXTURE, UV);
	if (apply_white) {
		vec4 white_color = vec4(1.0, 1.0, 1.0, tex_color.a);
		COLOR = mix(tex_color, white_color, whiteness_amount);
	} else {
		COLOR = tex_color;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
