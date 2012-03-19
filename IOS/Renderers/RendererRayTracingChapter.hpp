#include <iostream>

#include "Renderer.hpp" 
#include "Light.hpp" 
#include "Sphere.hpp" 
#include "Utils.hpp" 

#ifndef RENDERER_RAYTRACE_H
#define RENDERER_RAYTRACE_H


class RendererRayTracingChapter :  public Renderer {
  

public:
  //RendererRayTracingChapter(void* view);
  RendererRayTracingChapter();
  
  virtual void Initialize();
  virtual void Render();
  
  virtual void HandleTouchBegan(ivec2 mouse);
  virtual void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);

  vec3 CastRay(ray3 ray, Sphere* currentSphere, vector<Light*>& lights, vector<Sphere*>& spheres, int level);
  void CastRaysFromImagePlane(Camera* cam, vector<Light*>& lights, vector<Sphere*>& spheres, Texture* imageTexture);
  int CheckShadow(vec3 point, Sphere* currentSphere, Light* l, vector<Sphere*>& spheres);

  vector<Light*>& GetLights();
  vector<Sphere*>& GetSpheres();
  int GetRenderMode();
  void SetRenderMode(int _mode);
  

  
  

private:
  vector<Light*> lights;
  vector<Sphere*> spheres;
  Sphere* selectedSphere;
  bool sphereIsSelected;
  int mode;
  


};

#endif
