//static const char* SimpleVertexShader = STRINGIFY(

attribute vec4 Position;
attribute vec3 Normal;
//attribute vec3 DiffuseMaterial;

uniform mat4 Projection;
uniform mat4 Modelview;
uniform mat3 NormalMatrix;

//uniform vec3 LightPosition[MAXLIGHTS];
//uniform vec3 LightColor[MAXLIGHTS];

uniform vec3 LightPosition1;
uniform vec3 LightColor1;
uniform vec3 LightPosition2;
uniform vec3 LightColor2;
uniform vec3 LightPosition3;
uniform vec3 LightColor3;
//uniform vec3 LightPosition4;
//uniform vec3 LightColor4;



uniform vec3 AmbientMaterial;
uniform vec3 SpecularMaterial;
uniform vec3 DiffuseMaterial;
uniform float Shininess;

varying vec4 DestinationColor;

//want to pass in lots of lights... 
//uniform int NumLights;

void main(void) {
  mat3 nm = NormalMatrix;
  vec3 color = vec3(0.0,0.0,0.0);
  vec3 lC;
  vec3 N = Normal; //NormalMatrix * Normal;
  vec3 E = vec3(0, 0, 1);
  
  vec3 dm = DiffuseMaterial;
  vec3 sm = SpecularMaterial;
  vec3 am = AmbientMaterial;
  
  //int x = NumLights;
  /*
  vec3 lightColorsArr[3];
  lightColorsArr[0] = LightColor1;
  lightColorsArr[1] = LightColor2;
  lightColorsArr[2] = LightColor3;
//  lightColorsArr[3] = LightColor4;
//  
  vec3 lightPositionsArr[3];
  lightPositionsArr[0] = LightPosition1;
  lightPositionsArr[1] = LightPosition2;
  lightPositionsArr[2] = LightPosition3;
//  lightPositionsArr[3] = LightPosition4;
  
  //color = AmbientMaterial;
  */
  
  vec3 L1 = normalize(LightPosition1);
  vec3 L2 = normalize(LightPosition2);
  vec3 L3 = normalize(LightPosition3);
  float df1 = max(0.0, dot(N, L1));
  float df2 = max(0.0, dot(N, L2));
  float df3 = max(0.0, dot(N, L3));
  vec3 H1 = normalize(L1 + E);
  vec3 H2 = normalize(L2 + E);
  vec3 H3 = normalize(L3 + E);
  float sf1 = max(0.0, dot(N, H1));
  sf1 = pow(sf1, Shininess);
  float sf2 = max(0.0, dot(N, H2));
  sf2 = pow(sf2, Shininess);
  float sf3 = max(0.0, dot(N, H3));
  sf3 = pow(sf3, Shininess);
  
  vec3 lC1 = df1 * LightColor1 + sf1 * SpecularMaterial;
  vec3 lC2 = df2 * LightColor2 + sf2 * SpecularMaterial;
  vec3 lC3 = df3 * LightColor3 + sf3 * SpecularMaterial;
  
  
  color = AmbientMaterial + lC1 + lC2 + lC3;
  //color = vec3(1.0,0.0,0.0);
  /*
  for (int i = 0; i < NumLights; i++) {
      
    vec3 L = normalize(lightPositionsArr[i]);
    vec3 H = normalize(L + E);

    float df = max(0.0, dot(N, L));
    float sf = max(0.0, dot(N, H));
    sf = pow(sf, Shininess);

    //df = 1.0;
    //sf = 0.5;
    lC = df * (lightColorsArr[i]);
    //lC = vec3(0.3, 0.0, 0.0); //LightColor[i];
    //lightColor = AmbientMaterial + df * (LightColor[i]) + sf * SpecularMaterial;
    color = color + lC; //vec3(color.x + lC.x, color.y + lC.y, color.z + lC.z); 
  }
  
  //color = LightColor[0];
  //color = DiffuseMaterial; //vec3(0.0,1.0,0.0);
  */
  
  DestinationColor = vec4(color, 1.0);
  gl_Position = Projection * Modelview * Position;
}
//);
