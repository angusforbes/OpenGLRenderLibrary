precision lowp float; 
varying vec3 tc;                            
uniform sampler2D DuniteTexture; 
uniform float cols;
uniform float rows;
uniform float slices;
                  
void main() { 
  
  /** Force tex coords to be in range 0 -> 1 **/
  
  //mimic GL_REPEAT
  //vec3 modtc = mod(tc, vec3(1.0,1.0,1.0));
  
  //mimic GL_MIRRORED_REPEAT
  vec3 modtc = mod(tc, vec3(2.0,2.0,2.0));
  if (modtc.x > 1.0) {
    modtc.x = 2.0 - modtc.x;
  }
  
  if (modtc.y > 1.0) {
    modtc.y = 2.0 - modtc.y;
  }
  
  if (modtc.z > 1.0) {
    modtc.z = 2.0 - modtc.z;
  }
  
  /** Use the z value of tex coords to get the correct slice **/ 
  //use modtc.z to index into slice(s)
  
  float colInc = 1.0 / (cols);
  float rowInc = 1.0 / (rows);
  float sliceInc = 1.0 / (slices);
  
  //current slice
  float slice = floor(modtc.z / sliceInc);
  float useX = (floor(mod(slice,cols)) * colInc) + (colInc * modtc.x);
  float useY = (floor(slice / cols) * rowInc) + (rowInc * modtc.y);
  
  //prev slice
  float sliceP = slice - 1.0; 
  float useXP = (floor(mod(sliceP,cols)) * colInc) + (colInc * modtc.x);
  float useYP = (floor(sliceP / cols) * rowInc)+ (rowInc * modtc.y);
    
  //next slice 
  float sliceN = slice + 1.0; 
  float useXN = (floor(mod(sliceN,cols)) * colInc) + (colInc * modtc.x);
  float useYN = (floor(sliceN / cols) * rowInc) + (rowInc * modtc.y);
  

  vec4 color1 = texture2D( DuniteTexture, vec2(useXP, useYP) );
  vec4 color2 = texture2D( DuniteTexture, vec2(useX, useY) );
  vec4 color3 = texture2D( DuniteTexture, vec2(useXN, useYN) );
  vec4 color = vec4(color1.r, color2.g, color3.b, 1.0);
  //vec4 color = color2;
  
  gl_FragColor = color; 
  
}                                                 