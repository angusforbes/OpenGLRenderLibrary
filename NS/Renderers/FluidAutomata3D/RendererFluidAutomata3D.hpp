#include "Renderer.hpp" 

#ifndef RendererFluidAutomata3D_hpp
#define RendererFluidAutomata3D_hpp

class RendererFluidAutomata3D : public Renderer {
  
public:
  
  RendererFluidAutomata3D();
  
  virtual void Initialize();
  virtual void Render();
  
  void MakeTextureCoords();
  void HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function);
  
private:
  
};



#endif
