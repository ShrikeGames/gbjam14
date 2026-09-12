shader_type canvas_item;

uniform vec3 palette[3];
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_nearest,repeat_disable;
uniform bool shader_active = true;

void fragment() {
	//Find closest colour

	vec4 screen_texture_color = texture(SCREEN_TEXTURE,UV);
	vec4 difference = screen_texture_color - texture(TEXTURE, UV);
	float dist = dot(difference,difference); //Find length squared between difference and difference

	float closest_distance = dist; //Assume we already found the closest distance
	vec4 closest_color =  texture(SCREEN_TEXTURE,UV); 
	if(shader_active){
		
		for(int i = 0;i< palette.length(); i++)
		{
			vec3 new_difference = screen_texture_color.rgb - palette[i];
			dist = dot(new_difference,new_difference); // Get length

			if(dist<closest_distance){ //This colour must be closer to the original
				closest_distance = dist;
				closest_color.rgb = palette[i];
			}
		}
	}
	COLOR = closest_color;
}