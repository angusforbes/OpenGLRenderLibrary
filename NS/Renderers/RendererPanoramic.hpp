#include "Renderer.hpp" 
#include "Rectangle.hpp" 

#ifndef RENDERER_PANORAMIC_hpp
#define RENDERER_PANORAMIC_hpp

class RendererPanoramic : public Renderer {
  
  
public:
  RendererPanoramic();
  
  virtual void Initialize();
  virtual void Render();
  
  void CheckScale();
  void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
  void HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function);
private:
  
};


#endif

