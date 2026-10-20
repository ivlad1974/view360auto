#version 100
#ifdef GL_ES
// Set default precision to medium
precision mediump int;
precision mediump float;
#endif

uniform vec3 light_direction;

uniform vec3 ambient_color;
uniform vec4 diffuse_color;
uniform vec3 specular_color;
uniform float shininess;

varying vec4 v_color;
varying vec4 v_secondColor;

void ProcessLighting(vec3 eyeNormal)
{
	float diff = max(0.0, dot(eyeNormal, light_direction));
	v_color.rgb = diffuse_color.rgb * diff;
	v_color.rgb += ambient_color;
	v_color.a = diffuse_color.a;	

	vec3 vReflection = normalize(reflect(-light_direction, eyeNormal));
	float spec = max(0.0, dot(eyeNormal, vReflection));
	float fSpec = pow(spec, shininess);
	v_secondColor = vec4(specular_color * fSpec, 0.0);
}

