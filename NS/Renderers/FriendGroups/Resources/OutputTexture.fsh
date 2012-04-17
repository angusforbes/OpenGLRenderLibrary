
varying vec2 v_texCoord;                            
uniform sampler2D tex0;                       
uniform sampler2D tex1;                       
uniform sampler2D tex2;                       
uniform sampler2D tex3;                       
uniform sampler2D tex4;                       

float calcLuma(vec4 c) {
  return (c.r * 0.299 + c.g * 0.587 + c.b * 0.114);
  //return (c.r + c.r + c.g + c.g + c.g + c.b)/6.0;
}

void main() {         
  
  vec4 c0 = vec4(texture2D( tex0, v_texCoord ));  
  vec4 c1 = vec4(texture2D( tex1, v_texCoord ));  
  vec4 c2 = vec4(texture2D( tex2, v_texCoord ));  
  vec4 c3 = vec4(texture2D( tex3, v_texCoord ));  
  vec4 c4 = vec4(texture2D( tex4, v_texCoord ));  
  
  float y0 = calcLuma(c0);
  float y1 = calcLuma(c1);
  float y2 = calcLuma(c2);
  float y3 = calcLuma(c3);
  float y4 = calcLuma(c4);
  
  float y = y0;
  vec4 c = c0;
  
  
  if (y1 > y) {
    c = c1;
    y = y1;
  }
  
  if (y2 > y) {
    c = c2;
    y = y2;
  }
  
  if (y3 > y) {
    c = c3;
    y = y3;
  }
  if (y4 > y) {
    c = c4;
    y = y4;
  }
  
  /*
  if (y0 > 0.0) {
    c = c0; 
  } else if (y1 > 0.0) {
    c = c1; 
  } else if (y2 > 0.0) {
    c = c2;
  } else if (y3 > 0.0) {
    c = c3;  
  } else if (y4 > 0.0) {
    c = c4;
  }
  */
  gl_FragColor = c; 
}                                                 