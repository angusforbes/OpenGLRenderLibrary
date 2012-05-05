
#include "Renderer.hpp" 
#include "Rectangle.hpp" 

#ifndef OpenGLRenderLibrary_RendererVideoTexture_hpp
#define OpenGLRenderLibrary_RendererVideoTexture_hpp

class RendererVideoTexture : public Renderer {
  
  
public:
  RendererVideoTexture();
  //RendererVideoTexture(void* _view);
  
  virtual void Initialize();
  virtual void Draw();
  
  Texture* videoTexture;
  
private:
 
};


#endif

