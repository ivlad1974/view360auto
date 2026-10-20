#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D texture0;
uniform sampler2D texture1;
uniform sampler2D texture2;
uniform vec3 rgb_bias;


varying vec2 v_texcoord;
const mat3 yuv2RgbMat = mat3( 1.0,   1.0,   1.0,             
						0.0,  -0.39465,  2.03211,
						1.13983,   -0.58060,  0.0);

void main()
{
	vec3 yuv;
	vec3 rgb;
	yuv.x = texture2D(texture0, v_texcoord).r;
	yuv.y = texture2D(texture1, v_texcoord).r - 0.5;
	yuv.z = texture2D(texture2, v_texcoord).r - 0.5;
	yuv.x -= 0.0625;
	rgb = yuv2RgbMat * yuv;
	rgb = clamp(rgb + rgb_bias, 0.0, 1.0);
	return vec4(rgb, 1,0);
}

