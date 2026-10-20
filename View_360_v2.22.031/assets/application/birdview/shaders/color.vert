#version 100

attribute vec4 a_color;
varying vec4 v_color;

void ProcessColor()
{
	v_color = a_color;
}
