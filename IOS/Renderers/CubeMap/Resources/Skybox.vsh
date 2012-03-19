
attribute vec4 Position;

uniform mat4 Projection;
uniform mat4 Modelview;

varying vec3 vTexCoord;

void main(void) {

 gl_Position = Projection * Modelview * Position;
 
// vTexCoord = -normalize(Position.xyz);
  vTexCoord = -(Position.xyz);

}