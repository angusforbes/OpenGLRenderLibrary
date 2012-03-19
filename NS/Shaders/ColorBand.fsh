
varying vec2 v_texCoord;                            
uniform sampler2D s_tex;                       
uniform int band;
uniform int numBands;

float bandSize = 1.0 / float(numBands);
void main() {         
  vec4 color = texture2D( s_tex, v_texCoord );
  
  float avg = (color.r + color.g + color.b) / 3.0;
//  float avg;
//  
//  if (color.r > 0.0) {
//    avg = 1.0;
//  } else {
//    avg = 0.0;
//  }
  
  vec4 useColor = vec4(0.0,0.0,0.0,0.0);
  
  for (int i = 0; i < numBands; i++) {
    if (band == i && avg > float(i) * bandSize && avg <= float(i+1) * bandSize) {
      if (band == 0) {
        useColor = vec4(1.0,0.0,0.0,1.0);
      } else if (band == 1) {
        useColor = vec4(0.0,1.0,0.0,1.0);
        
      } else if (band == 2) {
        useColor = vec4(0.0,0.0,1.0,1.0);
        
      }
        
      //useColor = color; 
      break;
    }
  }
  
  //gl_FragColor = vec4(avg, avg, avg, 1.0);
  gl_FragColor = useColor;
  //gl_FragColor = vec4(float(2) * bandSize);
  /*
  if ((band == 0 && avg <= bandSize) || (band == 1 && avg > bandSize)) {
    gl_FragColor = color; 
  } else {
    discard;
    //gl_FragColor = vec4(0.0,0.0,0.0,0.0); 
  } 
  */
    //texture2D( s_tex, v_texCoord );
  //gl_FragColor = vec4(1.0,0.0,0.0,1.0); //texture2D( s_tex, v_texCoord );
  
}                                                 