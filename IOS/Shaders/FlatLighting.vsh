attribute vec4 Position;

uniform mat4 Projection;
uniform mat4 Modelview;

void main(void) {  
  gl_Position = Projection * Modelview * Position;
}

