#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D texture0;
uniform sampler2D texture1;

const mat3 yuv2RgbMat = mat3( 1.0,   1.0,   1.0,             
						0.0,  -0.39465,  2.03211,
						1.13983,   -0.58060,  0.0);

vec4 GetTextureRgba(vec2 texcoord)
{
	vec3 yuv;
	vec3 rgb;
	yuv.x = texture2D(texture0, texcoord).r;
	yuv.y = texture2D(texture1, texcoord).g - 0.5;
	yuv.z = texture2D(texture1, texcoord).a - 0.5;
	yuv.x -= 0.0625;
	rgb = yuv2RgbMat * yuv;
	return vec4(rgb, 1.0);
}

