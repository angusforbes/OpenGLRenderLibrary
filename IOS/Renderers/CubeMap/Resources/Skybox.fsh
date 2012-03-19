//precision mediump float; 
uniform samplerCube Sampler;
varying highp vec3 vTexCoord;
void main (void) {
  //vec4 color = textureCube(Sampler, vTexCoord);
  //gl_FragColor = color;
  //gl_FragDepth = color.r;
  //gl_FragColor = vec4(1.0,0.0,0.0,1.0);

  gl_FragColor = textureCube(Sampler, vTexCoord);

}