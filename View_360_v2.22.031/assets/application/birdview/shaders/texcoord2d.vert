#version 100
attribute vec3 a_texcoord;
varying vec2 v_texcoord;
void ProcessTexcoord()
{
	v_texcoord = a_texcoord.xy;
}
