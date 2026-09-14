shader_type canvas_item;

uniform vec4 reference_palette[4] : source_color;
uniform vec4 palette[4] : source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_nearest,repeat_disable;
uniform bool shader_active = true;

void fragment() {
	vec4 screen_texture_color = texture(SCREEN_TEXTURE, UV);
	vec4 closest_color = screen_texture_color;

	if(shader_active){
		float closest_distance = 1e20;
		int closest_index = 0;

		for(int i = 0;i< reference_palette.length(); i++)
		{
			float dist = distance(screen_texture_color.rgb, reference_palette[i].rgb);

			if(dist<closest_distance){
				closest_distance = dist;
				closest_index = i;
			}
		}

		closest_color.rgb = palette[closest_index].rgb;
	}
	COLOR = closest_color;
}
