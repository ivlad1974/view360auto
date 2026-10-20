#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform vec4 unif_color;

void main()
{
	gl_FragColor = unif_color;
}


