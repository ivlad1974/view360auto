#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform vec3 rgb_bias;
uniform vec3 avg_lum;
uniform float brightness;
uniform float contrast;
uniform float saturation;
varying float v_alpha;
varying vec2 v_texcoord;

vec4 GetTextureRgba(vec2 texcoord);
const vec3 lumBlend = vec3(0.2125, 0.7154, 0.0721);

void main()
{
	vec3 rgb = GetTextureRgba(v_texcoord).rgb;

	rgb = mix(avg_lum, rgb, contrast);
	rgb = clamp(rgb + rgb_bias, 0.0, 1.0);
	vec3 gray = vec3(dot(rgb, lumBlend));
	rgb = mix(gray, rgb, saturation);
	rgb = pow(rgb, vec3(2.0 - brightness));
	gl_FragColor = vec4(rgb, v_alpha);
}

