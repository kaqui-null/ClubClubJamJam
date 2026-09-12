shader_type canvas_item;

uniform vec3 palette[16] : source_color;
uniform uint grid[1440];
uniform int chars;
uniform sampler2D char_map : filter_nearest;

void vertex() {}

void fragment() {
	int x = int(floor(UV.x*48.0));
	int y = int(floor((1.-UV.y)*30.0));
	float ux = (UV.x*48.0)-float(x);
	float uy = ((1.-UV.y)*30.0)-float(y);
	
	int idx = int(grid[x+y*48]);
	int char = min(chars,(idx>>8)&0xff);
	vec3 color_fore = palette[idx&15];
	vec3 color_back = palette[(idx>>4)&15];
	
	vec4 charm = texture(char_map, vec2((ux+float(char))/float(chars),uy));
	vec3 color = round(charm.a)*color_back+(1.-round(charm.a))*color_fore;
	
	COLOR = vec4(color,1.);
}