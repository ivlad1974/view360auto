#version 100
#ifdef GL_ES
// Set default precision to medium
precision mediump int;
precision mediump float;
#endif
uniform mat4 mvp_matrix;
uniform mat4 joint_matrix[32];

attribute vec4 a_position;

varying highp vec4 v_worldPos;

void TransformPostion()
{
	int boneId = int(a_position.w);
	highp vec4 pos = vec4(a_position.xyz, 1.0);
	v_worldPos = joint_matrix[boneId] * pos;
	gl_Position = mvp_matrix * v_worldPos;
}
