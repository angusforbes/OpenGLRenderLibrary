#include "Renderer.hpp" 

#ifndef OpenGLRenderLibraryNS_RendererTexture3D_hpp
#define OpenGLRenderLibraryNS_RendererTexture3D_hpp

class RendererTexture3D : public Renderer {
  
public:
  
  RendererTexture3D();
  
  virtual void Initialize();
  virtual void Render();
  
  void MakeTextureCoords();
  void HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function);
  
private:
  
};



#endif
