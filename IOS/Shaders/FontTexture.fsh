precision mediump float; 
varying vec2 v_texCoord;                            
uniform sampler2D CharTex;                       
                    
void main() {         
  vec4 color = texture2D( CharTex, v_texCoord );

if (color.a > 0.0) {
  gl_FragColor = vec4(color.a, color.a,color.a, 1.0); //texture2D( s_tex, v_texCoord );
  } else {
  gl_FragColor = vec4(0.0, 0.0,0.0, 1.0); //texture2D( s_tex, v_texCoord );
  
  }
  
  //gl_FragColor = vec4(1.0,1.0,0.0,1.0); //texture2D( s_tex, v_texCoord );
  
}                                                 