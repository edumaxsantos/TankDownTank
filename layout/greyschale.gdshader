shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Convert the texture color to grayscale
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));

    // Calculate the blend factor based on the UV and progress
    float blend_factor = smoothstep(1.0 - progress, 1.0 - progress, UV.y);

    // Mix between grayscale and the original color based on the blend factor
    vec3 final_color = mix(vec3(gray), tex_color.rgb, blend_factor);

    COLOR = vec4(final_color, tex_color.a);
}