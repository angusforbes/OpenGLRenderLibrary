precision mediump float; 


uniform vec4 ContrastColor;
uniform vec4 BaseColor;
varying vec2 v_texCoord;

uniform float PhaseVal;
uniform float FreqVal;


void main() {
  
  
  vec2 pos = v_texCoord; 
  
  //Evaluate sine grating at requested position, frequency and phase: 
  //float sv1 = (sin(pos.x * FreqVal + PhaseVal) * 0.5) + 0.5; //between 0 and 1
  float sv1 = sin(pos.x * FreqVal + PhaseVal) ; //between -1 and 1
  
  //sv1 = smoothstep(0.0, 1.0, sv1); //make this a "sharpness" val
  
  sv1 = clamp(sv1, 0.0, 1.0); //make this a "sharpness" val
  // sv2 = (clamp(sv2, -1.0, 1.0) + 1.0)/2.0; //make this a "sharpness" val
  
  
 //probably faster to pass in a gaussian blur texture
//  float s = 0.15; //gaussian sigma
//  float powX2 = (pos.x-0.5) * (pos.x-0.5);
//  float powY2 = (pos.y-0.5) * (pos.y-0.5);
//  float powS2 = s * s;
//  float gauss = exp( -(  (powX2+powY2)  / (2.0 * powS2))  );
  float gauss = 1.0;
  vec4 usec1 = (vec4(sv1) * BaseColor); // + (vec4(1.0-sv1) * ContrastColor) ;
  
  gl_FragColor = vec4(usec1.xyz, gauss) ;
}                                               