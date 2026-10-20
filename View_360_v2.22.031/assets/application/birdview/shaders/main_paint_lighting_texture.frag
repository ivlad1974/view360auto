#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D texture_paint;

varying vec2 v_texcoord;
varying vec4 v_color;
varying vec4 v_secondColor;


void main()
{
	vec4 texColor = texture2D(texture_paint, v_texcoord);
	gl_FragColor = texColor.bgra * v_color + v_secondColor;
}


