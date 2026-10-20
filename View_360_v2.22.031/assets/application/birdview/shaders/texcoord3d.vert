#version 100
attribute vec3 a_texcoord;
varying vec2 v_texcoord;
varying float v_alpha;
void ProcessTexcoord()
{
	v_texcoord = a_texcoord.xy;
	v_alpha = a_texcoord.z;
}
