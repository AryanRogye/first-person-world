shader_type canvas_item;

uniform float blur : hint_range(0.0, 2.5);
uniform float brightness : hint_range(0.0, 1.0);

uniform sampler2D screen_texture : hint_screen_texture;

void vertex() {}

void fragment() {
	COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);
	COLOR.rgb *= brightness;
}
