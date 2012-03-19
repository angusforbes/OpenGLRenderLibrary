attribute vec4 position;   
attribute vec3 texCoord;   

uniform mat4 Projection;
uniform mat4 Modelview;
uniform float PhaseVal;
uniform float ThetaVal;

varying vec2 v_texCoord; 

/* Constants that we need 2*pi: */
const float twopi = 2.0 * 3.141592654;

/* Conversion factor from degrees to radians: */
const float deg2rad = 3.141592654 / 180.0;

/* Constant from setup code: Premultiply to contrast value: */
//uniform float contrastPreMultiplicator;

/* Attributes passed from Screen(): See the ProceduralShadingAPI.m file for infos: */
//attribute vec4 modulateColor;
//attribute vec4 auxParameters0;

/* Information passed to the fragment shader: Attributes and precalculated per patch constants: */
varying vec4  baseColor;
varying float Phase;
varying float FreqTwoPi;
//varying float Sigma;



void main()
{
    /* Apply standard geometric transformations to patch: */
    gl_Position = Projection * Modelview * position;

    /* Don't pass real texture coordinates, but ones corrected for hardware offsets (-0.5,0.5) */
    float x = texCoord.x;
    float y = texCoord.y;
    float theta = ThetaVal;
    
        
    float x2 = 0.5 + cos(theta)*(x-0.5) - sin(theta)*(y-0.5);
    float y2 = 0.5 + sin(theta)*(x-0.5) + cos(theta)*(y-0.5);
    
    v_texCoord = vec2(x2, y2);
    //v_texCoord = texCoord.xy;
    /* Contrast value is stored in auxParameters0[2]: */
    //float Contrast = auxParameters0[2];
    float Contrast = 1.0;

    /* Sigma value is stored in auxParameters0[3]: */
    //Sigma = auxParameters0[3];
    //Sigma = 0.0; //10.95;
    
    /* Convert Phase from degrees to radians: */
    //Phase = deg2rad * auxParameters0[0];
    Phase = deg2rad * PhaseVal;
//Phase = deg2rad * 0.0;

    /* Precalc a couple of per-patch constant parameters: */
    //FreqTwoPi = auxParameters0[1] * twopi;
    FreqTwoPi = 20.0 * twopi;

    //vec4 modulateColor = vec4(1.0,0.0,0.0,1.0);
    /* Premultiply the wanted Contrast to the color: */
    //baseColor = modulateColor * Contrast * contrastPreMultiplicator;
    baseColor = vec4(0.5,0.5,0.5,1.0);
}


/*

//uniform mat4 TextureMatrix;

varying vec2 v_texCoord;     
void main()                  
{                    
  gl_Position = Projection * Modelview * position;
  
  //gl_Position = position;  
  //v_texCoord = texCoord.xy;
  
  v_texCoord = (vec4(texCoord.xy, 0.0, 1.0)).xy;
}                            

*/

