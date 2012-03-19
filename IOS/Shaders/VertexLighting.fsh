//static const char* SimpleFragmentShader = STRINGIFY(

varying mediump vec4 DestinationColor;

void main(void)
{
  //gl_FragColor = vec4(0.0,1.0,0.0,1.0); 
  gl_FragColor = DestinationColor;
}
//);
