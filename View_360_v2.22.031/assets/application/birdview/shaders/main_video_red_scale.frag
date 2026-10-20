#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif
uniform float redFac;
varying float v_alpha;
const vec3 grayDot = vec3(0.299, 0.587, 0.114);
varying vec2 v_texcoord;

vec4 GetTextureRgba(vec2 texcoord);
void main()
{
	vec3 rgb = GetTextureRgba(v_texcoord).rgb;
	float gray = dot(rgb, grayDot);
	float redLumi = rgb.r * grayDot.r;
	vec3 rgbNew = rgb;
	rgbNew.r *= 1.0 - redLumi / gray;	//红色占亮度比例越大，衰减越大

	rgbNew = mix(rgbNew, vec3(gray, gray, gray), gray);		//高亮区使用去饱和度，低亮区使用红色衰减
	rgb = mix(rgb, rgbNew, redFac);
	gl_FragColor = vec4(rgb, v_alpha);
}

