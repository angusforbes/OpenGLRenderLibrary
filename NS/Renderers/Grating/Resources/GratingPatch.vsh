attribute vec4 position;   
attribute vec3 texCoord;   

uniform mat4 Projection;
uniform mat4 Modelview;

uniform float ThetaVal; //in radians
//uniform float ThetaVal2; //in radians

//uniform mediump vec4 Values1;
//uniform mediump vec4 Values2;

varying vec2 v_rotatedTexCoord; 
varying vec2 v_texCoord; 


void main() {
  
  gl_Position = Projection * Modelview * position;
  
  float x = texCoord.x;
  float y = texCoord.y;

  v_texCoord = vec2(x,y);

  //rotate around center 
  //float ThetaVal1 = Values1.z;
  float x1 = 0.5 + cos(ThetaVal)*(x-0.5) - sin(ThetaVal)*(y-0.5);
  float y1 = 0.5 + sin(ThetaVal)*(x-0.5) + cos(ThetaVal)*(y-0.5);
  
  //    float ThetaVal2 = Values2.z;
  //    float x2 = 0.5 + cos(ThetaVal2)*(x-0.5) - sin(ThetaVal2)*(y-0.5);
  //    float y2 = 0.5 + sin(ThetaVal2)*(x-0.5) + cos(ThetaVal2)*(y-0.5);
  
  v_rotatedTexCoord = vec2(x1, y1);
}
