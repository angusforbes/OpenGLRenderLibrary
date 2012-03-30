
varying vec2 v_texCoord;                            
uniform sampler2D s_tex;                       
                    
void main() {         
  vec4 color = texture2D( s_tex, v_texCoord );
  gl_FragColor = color; 
  
  
  //gl_FragColor = vec4(color.xyz, 0.7); //TEMP!!!
  
  //texture2D( s_tex, v_texCoord );
 // gl_FragColor = vec4(0.0,1.0,0.0,1.0); //texture2D( s_tex, v_texCoord );
  
}                                                 