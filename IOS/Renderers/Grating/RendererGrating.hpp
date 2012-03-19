#include "Renderer.hpp" 
#include "Rectangle.hpp" 
#include "TextureCamera.hpp"

#ifndef RENDERER_GRATING_hpp
#define RENDERER_GRATING_hpp

class RendererGrating : public Renderer {
  
  
public:
  
  float cx;
  float cy;
  TextureCamera* tc;
  float topVal;
  float botVal;
  
  RendererGrating();
  
  virtual void Initialize();
  virtual void Render();
  
  void CheckScale();
  void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
  void HandlePinch(float scale);
//  void HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function);
private:
  
};


#endif

