attribute vec4 position;   
attribute vec3 texCoord;   

uniform mat4 Projection;
uniform mat4 Modelview;
uniform mat4 texRotation;

varying vec3 v_texCoord;     
void main()                  
{                    
  gl_Position = Projection * Modelview * position;
  
//  vec3 pre = vec3(texCoord.x - 0.5, texCoord.y - 0.5, texCoord.z) ;
//  vec4 tR = texRotation * vec4(pre.xyz, 1.0);
//  vec3 post =  vec3(tR.x + 0.5, tR.y + 0.5, tR.z) ;  
//  v_texCoord = post;  

  vec4 tR2 = texRotation * vec4(texCoord.xyz, 1.0);
  v_texCoord = tR2.xyz;  
}                            