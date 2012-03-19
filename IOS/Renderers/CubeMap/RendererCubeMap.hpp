


#include "Renderer.hpp" 
#include "Matrix.hpp" 
#include "Cube.hpp" 

#ifndef RENDERER_CUBEMAP_H
#define RENDERER_CUBEMAP_H

class RendererCubeMap : public Renderer {
  
public:
  RendererCubeMap();
  //RendererCubeMap(void* view);
  
  virtual void Initialize();
  virtual void Render();
  
  virtual void HandleTouchBegan(ivec2 mouse);
  virtual void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
  virtual void HandleTouchEnded(ivec2 mouse);
  virtual void HandleLongPress(ivec2 mouse);
  virtual void HandlePinch(float scale);
  virtual void AddUI();
private:
  Cube* myCube;
  void UpdateCubeTexture(Texture* cubemap, int face, vec2 hitTexCoords);
  void IntersectCube(ivec2 mouse);
  void drawSkybox(Cube* cube, Texture* tex);
};


#endif
