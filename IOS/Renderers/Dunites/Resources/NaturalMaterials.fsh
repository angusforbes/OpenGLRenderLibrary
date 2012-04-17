precision mediump float; 
varying vec3 tc;                            

uniform sampler2D Tex0; 
uniform sampler2D Tex1;
uniform sampler2D Tex2;
uniform sampler2D Tex3;
uniform sampler2D Tex4;
uniform sampler2D Tex5;
uniform sampler2D Tex6;
uniform sampler2D Tex7;

uniform float textures; //number of textures

uniform float cols; //cols per texture
uniform float rows; //rows per texture
uniform float slices; //slices per texture
                  
void main() { 
  
  /** Force tex coords to be in range 0 -> 1 **/
  vec3 modtc = tc;
  
  //mimic GL_REPEAT
  modtc = mod(tc, vec3(1.0,1.0,1.0));
  
  //mimic GL_MIRRORED_REPEAT
//  vec3 modtc = mod(tc, vec3(2.0,2.0,2.0));
//  if (modtc.x > 1.0) {
//    modtc.x = 2.0 - modtc.x;
//  }
//  
//  if (modtc.y > 1.0) {
//    modtc.y = 2.0 - modtc.y;
//  }
//  
//  if (modtc.z > 1.0) {
//    modtc.z = 2.0 - modtc.z;
//  }
  
  /** Use the z value of tex coords to get the correct slice **/ 
  //use modtc.z to index into slice(s)
  
  float colInc = 1.0 / (cols);
  float rowInc = 1.0 / (rows);
  float sliceInc = 1.0 / (slices);
  
  float texInc = 1.0 / textures;
  
  //current slice
  float tex = floor(modtc.z / texInc);
  
  float slice = floor (( (modtc.z - (texInc * tex)) * textures) / sliceInc);
  //float slice = floor(modtc.z / sliceInc);
  
  //float slice = floor(modtc.z / sliceInc);
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
  
  vec4 color1;
  vec4 color2;
  vec4 color3;
  
  if (tex == 0.0) {
    color1 = texture2D( Tex0, vec2(useXP, useYP) );
    color2 = texture2D( Tex0, vec2(useX, useY) );
    color3 = texture2D( Tex0, vec2(useXN, useYN) );
    
    //color2 = vec4(1.0,0.0,0.0,1.0);
  } else if (tex == 1.0) {
    color1 = texture2D( Tex1, vec2(useXP, useYP) );
    color2 = texture2D( Tex1, vec2(useX, useY) );
    color3 = vec4(1.0,0.0,0.0,1.0); //texture2D( Tex1, vec2(useXN, useYN) );
    //color2 = vec4(1.0,0.5,0.0,1.0);
  } else if (tex == 2.0) {
    color1 = texture2D( Tex2, vec2(useXP, useYP) );
    color2 = texture2D( Tex2, vec2(useX, useY) );
    color3 = vec4(0.0,1.0,0.0,1.0); //texture2D( Tex1, vec2(useXN, useYN) );
   // color2 = vec4(1.0,1.0,0.0,1.0);
  } else if (tex == 3.0) {
    color1 = texture2D( Tex3, vec2(useXP, useYP) );
    color2 = texture2D( Tex3, vec2(useX, useY) );
    color3 = vec4(0.0,0.0,1.0,1.0); //texture2D( Tex1, vec2(useXN, useYN) );
    //color2 = vec4(0.5,1.0,0.0,1.0);
  } else if (tex == 4.0) {
    color1 = texture2D( Tex4, vec2(useXP, useYP) );
    color2 = texture2D( Tex4, vec2(useX, useY) );
    color3 = vec4(0.0,1.0,1.0,1.0); //texture2D( Tex1, vec2(useXN, useYN) );
    //color2 = vec4(0.5,0.5,0.0,1.0);
  } else if (tex == 5.0) {
    color1 = texture2D( Tex5, vec2(useXP, useYP) );
    color2 = texture2D( Tex5, vec2(useX, useY) );
    color3 = vec4(1.0,0.0,1.0,1.0); //texture2D( Tex1, vec2(useXN, useYN) );
    //color2 = vec4(0.5,0.5,0.5,1.0);
  } else if (tex == 6.0) {
    color1 = texture2D( Tex6, vec2(useXP, useYP) );
    color2 = texture2D( Tex6, vec2(useX, useY) );
    color3 = vec4(0.0,1.0,1.0,1.0); //texture2D( Tex1, vec2(useXN, useYN) );
    //color2 = vec4(0.5,1.0,0.5,1.0);
  } else {
    color1 = texture2D( Tex7, vec2(useXP, useYP) );
    color2 = texture2D( Tex7, vec2(useX, useY) );
    color3 = vec4(1.0,1.0,1.0,1.0); //texture2D( Tex1, vec2(useXN, useYN) );
    //color2 = vec4(0.5,1.0,1.0,1.0);
  }  
  
  vec4 color = vec4(color1.r, color2.g, color3.b, 1.0);
  //vec4 color = color2;
  
  gl_FragColor = color; 
  
}                                                 