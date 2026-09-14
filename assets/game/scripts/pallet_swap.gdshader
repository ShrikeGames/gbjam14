shader_type canvas_item;

uniform vec4 palette[4] : source_color;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_nearest,repeat_disable;
uniform bool shader_active = true;

void fragment() {
	vec4 screen_texture_color = texture(SCREEN_TEXTURE, UV);
	vec4 closest_color = screen_texture_color;

	if(shader_active){
		//Find closest colour. Start with a distance nothing can lose to,
		//so every pixel is forced onto the palette.
		float closest_distance = 1e20;

		for(int i = 0;i< palette.length(); i++)
		{
			vec3 new_difference = screen_texture_color.rgb - palette[i].rgb;
			float dist = dot(new_difference,new_difference); //Length squared

			if(dist<closest_distance){ //This colour must be closer to the original
				closest_distance = dist;
				closest_color.rgb = palette[i].rgb;
			}
		}
	}
	COLOR = closest_color;
}
