#include "Utils.hpp"
#include "Renderer.hpp"

using namespace std;

bool Utils::Epsilon(float val, float target, float range) {
 
  if (val > target - range && val < target + range) {
    return true;
  }
  
  return false;
  
}

void Utils::sleep(double seconds) {
  [NSThread sleepForTimeInterval:seconds];
}

float Utils::randomFloatBetween(float a, float b) {
  return ((b-a) * randomFloat()) + a;
}


float Utils::randomFloat() {
  return ((float)arc4random()/0x100000000);
}


int Utils::randomIntBetween(int a, int b) {
  return (int)a + (arc4random() % (b-a+1));
  //return (int) (((b-a) * [Utils randomDouble]) + a);
}

ray3 Utils::GetPickingRay(int mx, int my) {
  Camera* camera = Renderer::GetRenderer()->GetCamera();
ivec4 vp = camera->viewport; 
mat4 proj = camera->projection;
mat4 mv = camera->modelview;

vec3 atNearPlane = mat4::Unproject(mx, my, 0.0, mv, proj, vp);
vec3 atFarPlane = mat4::Unproject(mx, my, 1.0, mv, proj, vp);
return ray3(atNearPlane, (atFarPlane - atNearPlane));
}

int Utils::IntersectsWithRay2(ray3 theRay, Sphere* s, vec3* intersection) {
  
  vec3 rO = theRay.origin;
  vec3 rD = theRay.direction;
  
  vec3 pos = s->GetTranslate();
  float radius = s->GetScale().x; //assuming a uniform scale
  //printf("radius = %f\n", radius);
  
  vec3 eyeToPixelDir = rD;
  vec3 originMinusCenter = rO - pos;
  
  float a = eyeToPixelDir % eyeToPixelDir;
  float b = 2 * (originMinusCenter % eyeToPixelDir);
  float c = originMinusCenter % originMinusCenter;
  
  //  float a = vec3::Dot(eyeToPixelDir, eyeToPixelDir);
  //  float b = 2 * (vec3::Dot(originMinusCenter, eyeToPixelDir));
  //  float c = vec3::Dot(originMinusCenter, originMinusCenter);
  c -= (radius * radius);
  
  float bb4ac = b * b - 4 * a * c;
  
  if(bb4ac > 0) {
    float t1 = (-b + sqrt(bb4ac)) / (2 * a);
    float t2 = (-b - sqrt(bb4ac)) / (2 * a);
    
    float closestT = (t1 < t2) ? t1 : t2;
    
    if(closestT >= 0) {
      *intersection = rO + (eyeToPixelDir * closestT);
      return 1;
    }
  }
  
  *intersection = vec3(0,0,0);
  return 0;
}




int Utils::IntersectsWithRay(ray3 theRay, Sphere* s, vec3* intersection) {
  
  vec3 rO = theRay.origin;
  vec3 rD = theRay.direction;
  
  vec3 pos = vec3(0,0,0); //s.translate;
  float radius = 1; //s.scale;
  
  vec3 eyeToPixelDir = rD;
  vec3 originMinusCenter = rO - pos;
  
  float a = eyeToPixelDir % eyeToPixelDir;
  float b = 2 * (originMinusCenter % eyeToPixelDir);
  float c = originMinusCenter % originMinusCenter;
  
//  float a = vec3::Dot(eyeToPixelDir, eyeToPixelDir);
//  float b = 2 * (vec3::Dot(originMinusCenter, eyeToPixelDir));
//  float c = vec3::Dot(originMinusCenter, originMinusCenter);
  c -= (radius * radius);
  
  float bb4ac = b * b - 4 * a * c;
  
  if(bb4ac > 0) {
    float t1 = (-b + sqrt(bb4ac)) / (2 * a);
    float t2 = (-b - sqrt(bb4ac)) / (2 * a);
    
    float closestT = (t1 < t2) ? t1 : t2;
    
    if(closestT >= 0) {
      *intersection = rO + (eyeToPixelDir * closestT);
      return 1;
    }
  }
  
  *intersection = vec3(0,0,0);
  return 0;
}


  