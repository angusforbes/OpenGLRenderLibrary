precision lowp float; 


uniform vec4 Offset;

varying vec4  baseColor;
varying float Phase;
varying float FreqTwoPi;
varying vec2 v_texCoord;

void main()
{


		
    vec2 pos = v_texCoord; 


	//Evaluate sine grating at requested position, frequency and phase: 
	//float sv = (sin(pos.x * FreqTwoPi + Phase) + 1.0) * 0.5; // - 1.0;
	float sv = (sin(pos.x * FreqTwoPi + Phase) * 0.5) + 0.5; // - 1.0;
	//sv = smoothstep(0.2, 0.8, sv); //make this a "sharpness" val
	//sv = step(-0.9, sv) * 2.0 - 1.0;

 float s = 0.15; //gaussian sigma
  float powX2 = (pos.x-0.5) * (pos.x-0.5);
  float powY2 = (pos.y-0.5) * (pos.y-0.5);
  float powS2 = s * s;
  

 float gauss = exp( -(  (powX2+powY2)  / (2.0 * powS2)) );
//float gauss = 1.0;
  
  vec3 usec = vec3(sv,sv,sv);
  
  //gl_FragColor = vec4(usec + Offset.xyz, gauss) ;
  gl_FragColor = vec4(usec, gauss) ;
  //gl_FragColor = vec4(sv*gauss,sv*gauss,sv*gauss,1.0) ;
  
	//gl_FragColor = vec4(((baseColor * sv)+ Offset ).xyz, gauss) ;
  /*
  if (sv < 0.0 || sv > 1.0) {
    gl_FragColor = vec4(1.0,0.0,0.0, 1.0) ;
  } else
  gl_FragColor = vec4(sv,sv,sv, 1.0) ;
   */
  
}                                               