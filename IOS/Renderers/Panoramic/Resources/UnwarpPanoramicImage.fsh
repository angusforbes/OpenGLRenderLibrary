/*
void main() {         
  
gl_FragColor = vec4(1.0,0.0,0.0,1.0);

}
*/
precision mediump float; 

varying vec2 v_texCoord;                            
uniform sampler2D s_tex;                       
                 
uniform float centerX; //0.5
uniform float centerY; //0.5

const float innerRadius = 0.1; //0.08; 
const float outerRadius = 0.4; //0.4;

void main() {         
  
  float yWarpA =   0.1850 * 1.0;
  float yWarpB =   0.8184 * 1.0;
  float yWarpC =  -0.0028 * 2.0;
  //float yfrac = yWarpA*v_texCoord.y*v_texCoord.y + yWarpB*v_texCoord.y + yWarpC;
  float radius = ((outerRadius - innerRadius) * v_texCoord.y) + innerRadius;
  
  if (radius < innerRadius || radius > outerRadius) {
    gl_FragColor = vec4(1.0,0.0,0.0,1.0);
  } else {
  //radius = clamp(radius, innerRadius, outerRadius);
  
  //float radius = ((outerRadius - innerRadius) * yfrac) + innerRadius;
  float angle = v_texCoord.x * (3.14159 * 2.0);
  
  float nx = centerX + (radius * 1.0) * cos(angle);
  float ny = centerY + radius * sin(angle);
  
  
  
  //real one!!!
  vec4 color = texture2D( s_tex, vec2(nx, ny) );
  
  
  
  gl_FragColor = color; //texture2D( s_tex, v_texCoord );
  //gl_FragColor = vec4(1.0,0.0,0.0,1.0); //texture2D( s_tex, v_texCoord );
  }
  
  /*
  //test no unwarping
  vec4 color = texture2D( s_tex, v_texCoord );
  gl_FragColor = color;
  */
  
}  
                                               