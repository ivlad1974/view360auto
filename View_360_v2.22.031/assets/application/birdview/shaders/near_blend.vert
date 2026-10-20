#version 100
#ifdef GL_ES
// Set default precision to medium
precision mediump int;
precision mediump float;
#endif

varying vec4 v_color;

void NearCameraAlpha()
{
	v_color.a *= min(gl_Position.z / abs(gl_Position.w) * 4.0, 1.0);
}

