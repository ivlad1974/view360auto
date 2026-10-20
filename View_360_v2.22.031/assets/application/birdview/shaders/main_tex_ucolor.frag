#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform vec4 base_color;
varying vec2 v_texcoord;

vec4 GetTextureRgba(vec2 texcoord);

void main()
{
	gl_FragColor = GetTextureRgba(v_texcoord) * base_color;
}

