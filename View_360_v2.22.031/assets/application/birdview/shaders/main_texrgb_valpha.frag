#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

varying float v_alpha;
varying vec2 v_texcoord;

vec4 GetTextureRgba(vec2 texcoord);

void main()
{
	vec4 rgba = GetTextureRgba(v_texcoord);
	gl_FragColor = vec4(rgba.rgb, v_alpha * rgba.a);
}

