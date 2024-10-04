shader_type spatial;

uniform vec4 flash_color = vec4(1.0);
uniform float flash_modifier: hint_range(0.0, 1.0) = 0.0;

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 color = texture(TEXTURE,UV);
	color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);
	COLOR = color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
