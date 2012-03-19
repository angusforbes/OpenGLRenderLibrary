


#include "Renderer.hpp" 
#include "Matrix.hpp" 
#include "Cube.hpp" 

#ifndef RENDERER_COLORED_GRID_H
#define RENDERER_COLORED_GRID_H

class RendererColoredGrid : public Renderer {
  
public:
  //RendererCubeMap();
  RendererColoredGrid(void* view);
  
  virtual void Initialize();
  virtual void Render();
  
//  virtual void HandleTouchBegan(ivec2 mouse);
 virtual void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
//  virtual void HandleTouchEnded(ivec2 mouse);
//  virtual void HandleLongPress(ivec2 mouse);
//  virtual void HandlePinch(float scale);
  
private:
  //void UpdateCubeTexture(Texture* cubemap, int face, vec2 hitTexCoords);
  //void IntersectCube(ivec2 mouse);
};


#endif
