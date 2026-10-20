#version 100
#ifdef GL_ES
// Set default precision to medium
precision mediump int;
precision mediump float;
#endif

uniform vec3 light_direction;

uniform vec3 ambient_color;
uniform vec4 diffuse_color;

uniform vec3 eye_pos;

varying vec4 v_reflactionDir;
const float fresnel_fac = 2.5;


varying vec4 v_color;

void ProcessLighting(vec3 eyeNormal)
{
	float diff = max(0.0, dot(eyeNormal, light_direction));
	v_color.rgb = diffuse_color.rgb * diff;
	v_color.rgb += ambient_color;
	v_color.a = diffuse_color.a;	

	vec3 modelNormal = normalize(v_worldNormal);
	vec3 v_eyeDir = normalize(v_worldPos.xyz - eye_pos);
	v_reflactionDir.xyz = normalize(reflect(v_eyeDir, modelNormal));
	
	float c = abs(dot(v_eyeDir, modelNormal));
	float g = sqrt(fresnel_fac + c * c - 1.0);
	float f1 = (g - c) / (g + c);
	float f2 = (c * (g + c) - 1.0) / (c * (g - c) + 1.0);
	v_reflactionDir.w = 0.5 * f1 * f1 * (1.0 + f2 * f2);
	v_reflactionDir.w = max(min(v_reflactionDir.w, 1.0), 0.0);
}

