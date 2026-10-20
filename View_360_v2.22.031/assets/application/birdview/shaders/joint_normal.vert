#version 100
#ifdef GL_ES
// Set default precision to medium
precision mediump int;
precision mediump float;
#endif

attribute vec4 a_position;
attribute vec3 a_normal;
uniform mat3 normal_matrix;

uniform mat4 joint_matrix[32];

varying highp vec3 v_worldNormal;

vec3 TransformNormal()
{
	int boneId = int(a_position.w);
	v_worldNormal = normalize(mat3(joint_matrix[boneId]) * a_normal);
	return normalize(normal_matrix * v_worldNormal);
}

