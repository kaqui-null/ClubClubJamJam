shader_type canvas_item;

uniform vec2 camera_zoom = vec2(1.0);
uniform vec2 screen_size;
uniform vec2 light_pos;
uniform float light_angle = 1;
uniform sampler2D dither_atlas : filter_nearest;
uniform float falloff = 50;
uniform float intensity = 1;

varying vec2 world_position;

void vertex() {
	world_position = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy / camera_zoom;
}

float union(float a, float b) {
    return min(a,b);
}
float sub(float a, float b) {
    return max(-a,b);
}
float intersect(float a, float b ) {
    return max(a,b);
}
float xor(float a, float b) {
    return max(min(a,b),-max(a,b));
}
float union_s(float a, float b, float k) {
    k *= 4.0;
    float h = max(k-abs(a-b),0.0);
    return min(a, b) - h*h*0.25/k;
}
float sub_s(float a, float b, float k) {
    return -union_s(a,-b,k);
}
float intersect_s(float a, float b, float k) {
    return -union_s(-a,-b,k);
}

float dist_center_rect(vec2 p, vec2 dimensions) {
	vec2 d = abs(p)-dimensions;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}
float dist_abs(vec2 p, float a) {
	float x1 = (a*p.y+abs(p.x))/(1.+a*a)*(p.x>=0. ? 1. : -1.);
	return (p.y+abs(p.x)/a <= 0.) 
		? sqrt(p.x*p.x+p.y*p.y) 
		: sqrt(pow(x1-p.x,2)+pow(a*abs(x1)-p.y,2))
		* (p.y >= abs(p.x)*a ? -1. : 1.);
}

vec2 aln(vec2 p, vec2 bias) {
	return p*bias;
}
vec2 ang(float a) {
	return vec2(sin(a), cos(a));
}

vec2 rot(vec2 p, float a) {
	return vec2(
		p.x*cos(a)-p.y*sin(a),
		p.x*sin(a)+p.y*cos(a)
	);
}

float dist(vec2 dither_pos) {
	return union_s(
		dist_abs(rot(dither_pos-light_pos, light_angle), 2.5),
		distance(dither_pos,light_pos)-18.,
		5.
	);
}

void fragment() {
	vec2 dither_pd = fract(world_position/4.0);
	vec2 dither_pos = floor(world_position/4.0)*4.0;
	
	float dither_id = clamp(dist(dither_pos)/falloff-intensity,0.0,1.0);
	
	vec4 dither = texture(dither_atlas,vec2((dither_pd.x/17.0)+floor(dither_id*17.0)/17.0,dither_pd.y));
	
	COLOR = dither;
}
