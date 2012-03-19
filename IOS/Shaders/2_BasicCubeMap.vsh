attribute vec4 Position;
attribute vec3 Normal;

uniform mat4 Projection;
uniform mat4 Modelview;
uniform mat3 NormalMatrix; 

varying vec3 ReflectDir;

void main(void) {
  gl_Position = Projection * Modelview * Position;
  
  //vec3 N = NormalMatrix * Normal;
  vec3 N = normalize(NormalMatrix * Normal);
  vec3 E = (Modelview * Position).xyz;
  ReflectDir = reflect(-E, N);
}

