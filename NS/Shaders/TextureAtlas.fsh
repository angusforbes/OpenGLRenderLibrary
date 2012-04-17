//precision mediump float; 

varying vec2 v_texCoord;                            
uniform sampler2D s_tex;                       
uniform vec4 letterColor;

                      
void main() {         
  vec4 texColor = texture2D( s_tex, v_texCoord );
  gl_FragColor = texColor; 
  
  
  vec4 useColor = letterColor * texColor.a;
  gl_FragColor = vec4(useColor);
  //gl_FragColor = vec4(useColor.r,1.0, useColor.b, 1.0);
  
  //texture2D( s_tex, v_texCoord );
 // gl_FragColor = vec4(0.0,1.0,0.0,1.0); //texture2D( s_tex, v_texCoord );
  
}                                                 
