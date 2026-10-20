#version 100

uniform mat4 side_matrix;
uniform float blend_factor;
uniform vec4 camera_range;

attribute vec3 a_texcoord;
varying vec2 v_texcoord;
varying float v_alpha;
void ProcessTexcoord()
{
	v_texcoord = a_texcoord.xy;
	vec4 mesh_pos = gl_Position / gl_Position.w;
	vec4 side_pos = side_matrix * mesh_pos;

	v_texcoord = mix(v_texcoord, side_pos.xy, blend_factor);
	v_alpha = a_texcoord.z;
}
