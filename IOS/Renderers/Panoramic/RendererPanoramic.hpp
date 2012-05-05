#include "Renderer.hpp" 
#include "Rectangle.hpp" 
#include "TextureCamera.hpp"

#ifndef RENDERER_PANORAMIC_hpp
#define RENDERER_PANORAMIC_hpp

class RendererPanoramic : public Renderer {
  
  
public:
  
  float cx;
  float cy;
  TextureCamera* tc;
  float topVal;
  float botVal;
  
  RendererPanoramic();
  
  virtual void Initialize();
  virtual void Draw();
  
  void CheckScale();
  void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
  void HandlePinch(float scale);
//  void HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function);
private:
  
};


#endif

