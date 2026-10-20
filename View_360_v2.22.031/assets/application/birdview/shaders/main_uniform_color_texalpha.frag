#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif
uniform sampler2D texture_image;
uniform vec4 unif_color;

varying vec2 v_texcoord;

void main()
{
	gl_FragColor = unif_color;
	gl_FragColor.a *= texture2D(texture_image, v_texcoord).r;
}


