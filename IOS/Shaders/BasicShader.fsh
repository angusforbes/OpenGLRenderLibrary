
varying mediump vec3 ReflectDir;

uniform samplerCube Sampler;

void main(void) {
  //gl_FragColor = vec4(ReflectDir.xyz, 1.0);
  gl_FragColor = textureCube(Sampler, ReflectDir);
  //gl_FragColor = vec4(1.0,0.0,0.0,1.0); //textureCube(Sampler, ReflectDir);
}

