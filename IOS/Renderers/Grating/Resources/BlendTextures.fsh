precision mediump float; 

varying vec2 v_texCoord;
uniform sampler2D tex0;
uniform sampler2D tex1;

void main() {

  vec4 c1 = texture2D(tex0, v_texCoord);
  vec4 c2 = texture2D(tex1, v_texCoord);
  
  //probably faster to pass in a gaussian blur texture
  float s = 0.15; //gaussian sigma
  float powX2 = (v_texCoord.x-0.5) * (v_texCoord.x-0.5);
  float powY2 = (v_texCoord.y-0.5) * (v_texCoord.y-0.5);
  float powS2 = s * s;
  float gauss = exp( -(  (powX2+powY2)  / (2.0 * powS2))  );

  vec4 c3 = vec4(mix(c1, c2, 0.5).xyz, gauss);
  gl_FragColor = c3;
  //gl_FragColor = vec4(1.0,0.0,0.0,1.0);
  
}                                               