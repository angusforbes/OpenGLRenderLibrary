//precision mediump float; 

uniform int Pulse;

uniform int Step;
uniform float Thickness;

uniform vec4 ContrastColor;
uniform vec4 BaseColor;

varying vec2 v_rotatedTexCoord;
varying vec2 v_texCoord;

uniform float PhaseVal;
uniform float FreqVal;

uniform sampler2D Mask;

uniform int Selected;

void main() {
  
  
  vec2 pos = v_rotatedTexCoord; 
  
  //Evaluate sine grating at requested position, frequency and phase: 
  float sv1 = sin(pos.x * FreqVal + PhaseVal) ; //between -1 and 1
  
  sv1 = (sv1 + 1.0)/2.0; //place between 0.0 and 1.0
  
  vec4 maskColor = texture2D(Mask, v_texCoord);
  
  
  if (Pulse == 0) {
    
    if (Step == 1) {
      sv1 = step(Thickness, sv1); 
    }
    
    //currently encoding a border as red pixels...
    if (maskColor.r > 0.0) {
      gl_FragColor = vec4(maskColor.r, maskColor.r, maskColor.r, 0.5);
      //gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);  
    } else {
      vec4 useColor = (vec4(sv1) * BaseColor) + (vec4(1.0-sv1) * ContrastColor) ;
      gl_FragColor = vec4(useColor) * maskColor.a;
    }
    
  } else {
    //currently encoding a border as red pixels...
    if (maskColor.r > 0.0) {
      gl_FragColor = vec4(maskColor.r, maskColor.r, maskColor.r, 0.5);
      //gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);  
    } else {
    float sv2 = sin(FreqVal + PhaseVal) ; //between -1 and 1
    sv2 = (sv2 + 1.0)/2.0; //place between 0.0 and 1.0
    sv2 = (sv2 * 0.7); //place between 0.0 and 0.7;
    sv2 = sv2 + 0.3; //place between 0.3 and 1.0;
    
    //sv2 = clamp(sv2, 0.3, 0.7);
    gl_FragColor = vec4(BaseColor) * sv2 * maskColor.a;
    }
    
  }
  
  if (Selected == 1) {
    if (v_texCoord.x > 0.4 && v_texCoord.x < 0.6 && 
      v_texCoord.y > 0.4 && v_texCoord.y < 0.6) {
    gl_FragColor = vec4(1.0,1.0,1.0,1.0);

    }
  }
}                                               