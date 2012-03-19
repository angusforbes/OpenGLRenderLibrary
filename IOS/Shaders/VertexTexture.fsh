precision mediump float; 
varying vec2 v_texCoord;                            
uniform sampler2D s_tex;           
uniform lowp sampler3D s_tex2; 
uniform mat4 Projection;
uniform mat4 Modelview;
varying vec2 pos;

struct SRay {
  vec3 Origin;
  vec3 Direction;
};

//another ray tracing method that doesn't require transforming camera ray to obj coords
//http://sizecoding.blogspot.com/2008/11/intersecting-ray-with-spheres-glsl.html
//p: the point of origin of the ray. 
//rd: ray direction.
//si: OUTPUT, the closest sphere hit.
//t is returned, the distance to the closest intersection point.
//spheres are a vec4 is (x,y,z,r2): centre and radius squared.
//Of course to get the actual intersection you need to do this in the main routine:
//if (t!=999.9) inter=p+t*rd;

float isect (in vec3 p, in vec3 rd, in vec4 spherePt) { //, out vec4 si){
  float t=999.9,tnow,b,disc;
  //for (int i=0; i<4; i++) {  //each sphere
    tnow = 9999.9;           //temporary closest hit is far away
    //next 4 lines are the intersect routine for a sphere
    //vec3 sd=sph[i].xyz-p;    
    
  vec3 sd=spherePt.xyz-p;    
  
  b = dot ( rd,sd );
    //disc = b*b + sph[i].w - dot ( sd,sd );
    disc = b*b + spherePt.w - dot ( sd,sd );
  
  if (disc>0.0) {tnow = b - sqrt(disc);}
   
  // hit, so compare and store if this is the closest
    if ((tnow>0.0001)&&(t>tnow)) {
      t=tnow; //si=sph[i];
      return t;
    } else {
   
  return -1000.0;
    }
 // }
 // return t;
}


bool IntersectSphere ( SRay ray, float sqrradius, out float start ) {
	
  float A = dot ( ray.Direction, ray.Direction );
	
  float B = dot ( ray.Direction, ray.Origin );
	float C = dot ( ray.Origin, ray.Origin ) - sqrradius;
  
	float D = B * B - A * C;
	
  
	if ( D > 0.0 ) {
		//D = 1.0;
    D = sqrt ( D );
		start = max ( 0.0, ( -B - D ) / A );
		//start = 0.0;
    return D > B;
	}
  
  
	return false;
}

void main() {         
  
  vec3 origin = vec3(0.0, 0.0, 0.0);
  vec3 direction = vec3(pos.x, pos.y, 0.0);
  
  
  
  float xinc = 1.0 / 50.0; //i.e. texture incrememnt (fixed at 50pixels)
  float yinc = 1.0 / 50.0; //i.e. texture incrememnt (fixed at 50pixels)
  
  float closestDepth = 1000.0;
  vec4 useColor = vec4(1.0,0.0,0.0,1.0);
  float i;
  float j;
  for (i = -5.0; i < 5.0; i+=1.0) { 
    for (j = -5.0; j < 5.0; j+=1.0) { 
        
    //for (int i = -3; i < 3; i+=1) { 
      
    vec2 texVal = vec2(v_texCoord.x + (i * xinc), v_texCoord.y + (j * yinc));
    //vec2 texVal = vec2(0.5, 0.5);
    vec4 color = texture2D( s_tex, texVal );
  
    float zVal = ((color.x + color.y + color.z) / 3.0) * 0.01;
  
    //vec3 cameraObjCoords = vec3(0.0,0.0,-1.0) * zVal - vec3(1.0, 0.0, 0.0) * pos.x + vec3(0.0, 1.0, 0.0) * pos.y;
    //SRay rayToFragment = SRay ( vec3(0,0,0), normalize (cameraObjCoords) );
    
    
    vec4 spherePt = vec4(pos.x, pos.y, zVal, xinc *4.0);
    //(in vec3 p, in vec3 rd, in vec4 spherePt)
    
    
    float ival = isect ( origin, direction, spherePt );
    if ( ival > 0.0 ) {
      
      if (ival < closestDepth) {
        closestDepth = ival;
        useColor = color;
      }
      
    }
    /*
    
    float time;
    
    
    if ( IntersectSphere ( rayToFragment, inc*1.1, time ) ) {
      
      if (time < closestDepth) {
        closestDepth = time;
        useColor = color;
      }
      
    }
    */
  }
  }
  
  
  //gl_FragColor = vec4(1.0,0.0,0.0,1.0); //texture2D( s_tex, v_texCoord );
  //gl_FragColor = texture2D( s_tex, v_texCoord );
  gl_FragColor = useColor;
  
  
  
}                                                 