#version 100

uniform mat4 mvp_matrix;
attribute vec4 a_position;

void TransformPostion()
{
	gl_Position = mvp_matrix * a_position;
}
