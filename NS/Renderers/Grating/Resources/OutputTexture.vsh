attribute vec4 position;   
attribute vec3 texCoord;   

uniform mat4 Projection;
uniform mat4 Modelview;

varying vec2 v_texCoord;     
void main()                  
{                    
  gl_Position = Projection * Modelview * position;
  
  //gl_Position = position;  
  v_texCoord = texCoord.xy;
}                            