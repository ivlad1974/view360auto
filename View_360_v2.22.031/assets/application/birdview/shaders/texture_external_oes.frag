#version 100
#extension GL_OES_EGL_image_external : require
#ifdef GL_ES
precision mediump int;
precision mediump float;
#endif

uniform samplerExternalOES texture0;

vec4 GetTextureRgba(vec2 texcoord)
{
	return texture2D(texture0, texcoord);
}

