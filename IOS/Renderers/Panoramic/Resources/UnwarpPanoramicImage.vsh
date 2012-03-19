attribute vec4 position;   
attribute vec3 texCoord;   

uniform mat4 Projection;
uniform mat4 Modelview;

uniform mat4 TextureMatrix;

varying vec2 v_texCoord;     
void main()                  
{                    
  gl_Position = Projection * Modelview * position;
  
  //gl_Position = position;  
  //v_texCoord = texCoord.xy;
  
  v_texCoord = (TextureMatrix * vec4(texCoord.xy, 0.0, 1.0)).xy;
}                            