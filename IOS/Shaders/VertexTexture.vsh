attribute vec4 position;   
attribute vec2 texCoord;   

uniform mat4 Projection;
uniform mat4 Modelview;

varying vec2 v_texCoord;  
varying vec2 pos;

uniform sampler2D s_tex;

void main()                  
{ 
  
  //useColor = texture2D(s_tex, texCoord);
  
  //float offset = -((useColor.r + useColor.g + useColor.b) / 3.0) * 1.5;
  //float offset = -(useColor) * 2.0;
  
  //vec4 alteredPos = vec4(position.x, position.y, position.z + offset, position.w) ;
  //gl_Position = Projection * Modelview * alteredPos;
  
  vec4 thePos = position - vec4(1,1,0,0); //Projection * Modelview * position;
  pos = thePos.xy;
  gl_Position = thePos;
  v_texCoord = texCoord;  
}                            