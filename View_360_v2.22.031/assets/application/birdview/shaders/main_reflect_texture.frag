#version 100
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform sampler2D texture_paint;
uniform samplerCube texture_env;
uniform float reflect_fac;

varying vec2 v_texcoord;
varying vec4 v_color;
varying vec4 v_reflactionDir;
const vec3 lumBlend = vec3(0.2125, 0.7154, 0.0721);

float scalfac = 0.005;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) - 0.5;
}
void main()
{
	vec4 texColor = texture2D(texture_paint, v_texcoord);
	gl_FragColor = texColor.bgra * v_color;
	vec3 noiseDir;
	noiseDir.x = rand(v_reflactionDir.yz) * scalfac + v_reflactionDir.x;
	noiseDir.y = rand(v_reflactionDir.xz) * scalfac + v_reflactionDir.y;
	noiseDir.z = rand(v_reflactionDir.xy) * scalfac + v_reflactionDir.z;
	vec3 cube = textureCube(texture_env, noiseDir).bgr;
	float lightBri = max(dot(gl_FragColor.rgb, lumBlend), 0.1);
	float cubeBri = dot(cube, lumBlend);
	vec3 mixCube = mix(gl_FragColor.rgb, gl_FragColor.rgb * cube, cubeBri * reflect_fac);
	vec3 alphaCube = cube * pow(cubeBri, 1.0 / lightBri) * reflect_fac * gl_FragColor.a;
	gl_FragColor.rgb = mixCube + alphaCube;
	gl_FragColor.a = mix(gl_FragColor.a, 1.0, v_reflactionDir.w);
}


