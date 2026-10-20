#version 100
#ifdef GL_ES
// Set default precision to medium
precision mediump int;
precision mediump float;
#endif

void TransformPostion();
vec3 TransformNormal();
void ProcessLighting(vec3 eyeNormal);
void NearCameraAlpha();
void ProcessTexcoord();

void main(void)
{
	TransformPostion();
	vec3 transNormal = TransformNormal();
	ProcessLighting(transNormal);
	NearCameraAlpha();
	ProcessTexcoord();
}


