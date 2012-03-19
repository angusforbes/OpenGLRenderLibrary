
varying vec2 v_texCoord;                            
uniform sampler2D s_tex;                       
uniform float fWidth; //= 600.0;
uniform float fHeight; //= 400.0;


float BSpline( float x )
{
	float f = x;
	if( f < 0.0 )
	{
		f = -f;
	}
  
	if( f >= 0.0 && f <= 1.0 )
	{
		return ( 2.0 / 3.0 ) + ( 0.5 ) * ( f* f * f ) - (f*f);
	}
	else if( f > 1.0 && f <= 2.0 )
	{
		return 1.0 / 6.0 * pow( ( 2.0 - f  ), 3.0 );
	}
	return 1.0;
}
float Triangular( float f )
{
	f = f / 2.0;
	if( f < 0.0 )
	{
		return ( f + 1.0 );
	}
	else
	{
		return ( 1.0 - f );
	}
	return 0.0;
}

void main() {
  
  
  
  //float inc = 1.0/
  vec2 TexCoord = v_texCoord; //gl_TexCoord[0].st;
  
  
  
  
  float texelSizeX = 1.0 / fWidth; //size of one texel 
  float texelSizeY = 1.0 / fHeight; //size of one texel 
  vec4 nSum = vec4( 0.0, 0.0, 0.0, 0.0 );
  vec4 nDenom = vec4( 0.0, 0.0, 0.0, 0.0 );
  float a = fract( TexCoord.x * fWidth ); // get the decimal part
  float b = fract( TexCoord.y * fHeight ); // get the decimal part
  for( int m = -1; m <=2; m++ )
  {
    for( int n =-1; n<= 2; n++)
    {
			vec4 vecData = texture2D(s_tex, 
      TexCoord + vec2(texelSizeX * float( m ), texelSizeY * float( n )));
			float f  = BSpline( float( m ) - a );
			vec4 vecCooef1 = vec4( f,f,f,f );
			float f1 = BSpline ( -( float( n ) - b ) );
			vec4 vecCoeef2 = vec4( f1, f1, f1, f1 );
      nSum = nSum + ( vecData * vecCoeef2 * vecCooef1  );
      nDenom = nDenom + (( vecCoeef2 * vecCooef1 ));
    }
  }
  
  //gl_FragColor = texture2D(s_tex, TexCoord);
  gl_FragColor = nSum / nDenom;
  
  
  
  /*
  
  //vec2 ij = gl_TexCoord[0].st;
  //vec2        xy = floor(ij);
  //vec2 normxy = ij - xy;
 
//  vec2 st0 = ((2.0 - normxy) * normxy - 1.0) * normxy;
//  vec2 st1 = (3.0 * normxy - 5.0) * normxy * normxy + 2.0;
//  vec2 st2 = ((4.0 - 3.0 * normxy) * normxy + 1.0) * normxy;
//  vec2 st3 = (normxy - 1.0) * normxy * normxy;
//  
  vec2 st0 = vec2(2.0*xinc    )((2.0 - normxy) * normxy - 1.0) * normxy;
  vec2 st1 = (3.0 * normxy - 5.0) * normxy * normxy + 2.0;
  vec2 st2 = ((4.0 - 3.0 * normxy) * normxy + 1.0) * normxy;
  vec2 st3 = (normxy - 1.0) * normxy * normxy;
  
  vec4 row0 =
  st0.s * texture2D(s_tex, xy + vec2(-1.0, -1.0)) +
  st1.s * texture2D(s_tex, xy + vec2(0.0, -1.0)) +
  st2.s * texture2D(s_tex, xy + vec2(1.0, -1.0)) +
  st3.s * texture2D(s_tex, xy + vec2(2.0, -1.0));
  
  vec4 row1 =
  st0.s * texture2D(s_tex, xy + vec2(-1.0, 0.0)) +
  st1.s * texture2D(s_tex, xy + vec2(0.0, 0.0)) +
  st2.s * texture2D(s_tex, xy + vec2(1.0, 0.0)) +
  st3.s * texture2D(s_tex, xy + vec2(2.0, 0.0));
  
  vec4 row2 =
  st0.s * texture2D(s_tex, xy + vec2(-1.0, 1.0)) +
  st1.s * texture2D(s_tex, xy + vec2(0.0, 1.0)) +
  st2.s * texture2D(s_tex, xy + vec2(1.0, 1.0)) +
  st3.s * texture2D(s_tex, xy + vec2(2.0, 1.0));
  
  vec4 row3 =
  st0.s * texture2D(s_tex, xy + vec2(-1.0, 2.0)) +
  st1.s * texture2D(s_tex, xy + vec2(0.0, 2.0)) +
  st2.s * texture2D(s_tex, xy + vec2(1.0, 2.0)) +
  st3.s * texture2D(s_tex, xy + vec2(2.0, 2.0));
  
  //gl_FragColor.rgba = 0.25 * ((st0.t * row0) + (st1.t * row1) + (st2.t * row2) + (st3.t * row3));

  gl_FragColor.rgba = vec4(0.4, ij.y, 0.0, 1.0); //texture2D(s_tex, ij);
   */
}


