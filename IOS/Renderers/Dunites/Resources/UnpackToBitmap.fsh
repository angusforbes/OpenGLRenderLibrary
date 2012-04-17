precision mediump float;
precision highp int;

//precision highp float;
//precision highp int;

varying vec3 tc;                            

uniform sampler2D LookUpTexture; //4x4
uniform sampler2D PackedTexture0; 

uniform float textures; //number of textures
uniform float cols; //cols per texture
uniform float rows; //rows per texture
uniform float slices; //slices per texture

uniform float PackedWidth;
uniform float PackedHeight;
//uniform float LookUpWidth;
//uniform float LookUpHeight;

const float mult256 = 256.0;
const float mult255 = 255.0;

int checkBit(int Bits, int Val, int Pos) {

  int remainder = Val;
  for (int i = int(pow(2.0,float(Bits))); i >= 1; i = i/2) {
    if (remainder / i == 1) {
     if (Pos == i) { return 1; }
        remainder = remainder - i; 
    }

    if (i <= Pos) { return 0; }
  }

  return 0;
}


void main() { 


  vec4 outputColor;

  /** Force tex coords to be in range 0 -> 1 **/
  vec3 modtc = tc;
  //vec3 modtc = vec3(tc.x, tc.y, 0.0);

  float colInc = 1.0 / (cols);
  float rowInc = 1.0 / (rows);
  float sliceInc = 1.0 / (slices);
  
  float texInc = 1.0 / textures;
  
  //current slice
  float texdiv = modtc.z / texInc;
  float tex = floor(texdiv);
  
  float texIncMult = texInc * tex;
  float modMinusTexIncMult = modtc.z - (texIncMult); 
  float timesTextures =  ( modMinusTexIncMult ) * textures;
  float divSliceInc = ( timesTextures  ) / sliceInc;
  float slice = floor(divSliceInc);
  //float slice = floor(modtc.z / sliceInc);
  slice = 0.0;
  
  float modSlice = mod(slice,cols);
  float modFloor = floor(modSlice); 
  float floorTimeColInc = modFloor * colInc; 
  float colIncTimeMod = colInc * modtc.x;
  float useX = (floorTimeColInc) + (colIncTimeMod);
  
  float sliceDivCols = slice / cols; 
  float floorSlice = floor(sliceDivCols);
  float sliceTimesRowInc = sliceDivCols * rowInc; 
  float rowIncTimesMod = rowInc * modtc.y;
  float useY = (sliceTimesRowInc) + (rowIncTimesMod);
  

  //vec4 PackedColor = texture2D(PackedTexture0, tc.xy ); 
  vec4 PackedColor = texture2D(PackedTexture0, vec2(useX, useY) ); 


  float pwInc = 1.0/PackedWidth;
  float phInc = 1.0/PackedHeight;

  
  float lux = mod(tc.x, pwInc) * PackedWidth; //now have a lookup coord is between 0.0 and 1.0
  float luy = mod(tc.y, phInc) * PackedHeight; //now have a lookup coord is between 0.0 and 1.0

  int which; 

  vec4 lookupVec = texture2D(LookUpTexture, vec2(lux, luy));
  float bitfloat = lookupVec.r * mult256;
  int bit = int(bitfloat);  


 float pG = PackedColor.g;
    float pG255 = mult255 * pG;
    int iG = int(pG255);

 float pR = PackedColor.r;
    float pR255 = mult255 * pR;
    int iR = int(pR255);

  int isOn = 0;
/*

  if (luy >= 0.5) {
  
    luy -= 0.5;
    which = 1; //green
    
       isOn = checkBit(8, iG, bit);
  } else {
    which = 0;
   
    isOn = checkBit(8, iR, bit);
  }

*/
  luy *= 2.0;


if (luy < 0.5) {
 
  if (lux <= 0.25) {
    bit = 1; 
  } else if (lux < 0.5) {
    bit = 2; 
  } else if (lux < 0.75) {
    bit = 4; 
  } else {
    bit = 8; 
  }
} else {
 
  if (lux < 0.25) {
    bit = 16; 
  } else if (lux < 0.5) {
    bit = 32; 
  } else if (lux < 0.75) {
    bit = 64; 
  } else {
    bit = 128; 
  }
}




if (which == 0) {
  isOn = checkBit(8, iR, bit);
} else {
  isOn = checkBit(8, iG, bit);
}

outputColor = vec4(0.0,0.0,0.0,1.0);


if (isOn == 1) {
  outputColor = vec4(1.0,1.0,1.0,1.0);
}


//max int size = 32 bit, at least on simulator
//if (int(2147483648.0) == 2147483648) {
//  outputColor = vec4(1.0,0.0,1.0,1.0);
//}

gl_FragColor = outputColor;

}                                                 