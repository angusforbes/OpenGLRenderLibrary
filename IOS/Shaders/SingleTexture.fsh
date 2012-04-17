precision mediump float; 
varying vec2 v_texCoord;                            
uniform sampler2D s_tex;                       
                    
void main() {         
  vec4 color = texture2D( s_tex, v_texCoord );

  gl_FragColor = color; //texture2D( s_tex, v_texCoord );

//  gl_FragColor = vec4(color.a, color.a,color.a,1.0); //texture2D( s_tex, v_texCoord );
  
  //gl_FragColor = vec4(1.0,1.0,0.0,1.0); //texture2D( s_tex, v_texCoord );
  
}                                                 