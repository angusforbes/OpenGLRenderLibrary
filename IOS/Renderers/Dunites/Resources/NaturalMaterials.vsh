attribute vec4 position;   
attribute vec3 texCoord;   

uniform mat4 Projection;
uniform mat4 Modelview;
uniform mat4 TextureMatrix;

varying vec3 tc;     
void main()                  
{                    
  gl_Position = Projection * Modelview * position;
  
  tc = (TextureMatrix * vec4(texCoord.xyz, 1.0)).xyz;  
}                            