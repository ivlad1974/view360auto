#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D texture0;

vec4 GetTextureRgba(vec2 texcoord)
{
	return texture2D(texture0, texcoord);
}

