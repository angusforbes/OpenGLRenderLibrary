
varying vec3 v_texCoord;                            
uniform sampler3D s_tex;  
//uniform float tcValX;
//uniform float tcValY;
//uniform float tcValZ;
                    
void main() {         
  vec4 color = texture3D( s_tex, v_texCoord );
  //vec4 color = texture3D( s_tex, vec3(tcValX, tcValY, tcValZ) );
  
  gl_FragColor = color; //texture2D( s_tex, v_texCoord );
  //gl_FragColor = vec4(1.0,0.0,0.0,1.0); //texture2D( s_tex, v_texCoord );
  
}                                                 