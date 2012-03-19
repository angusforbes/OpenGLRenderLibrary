uniform samplerCube Sampler;

varying highp vec3 ReflectDir;


void main(void) {
  //gl_FragColor = vec4(ReflectDir.xyz, 1.0);
  gl_FragColor = textureCube(Sampler, ReflectDir);
  //gl_FragColor = vec4(1.0,0.0,0.0,1.0); //textureCube(Sampler, ReflectDir);
}

