#include "Renderer.hpp" 
#include "TextureCamera.hpp"
#include "IOSGLView.h"

#ifndef OpenGLRenderLibraryNS_RendererDunites_hpp
#define OpenGLRenderLibraryNS_RendererDunites_hpp

class RendererDunites : public Renderer {
  
public:
  
  RendererDunites();
  
  virtual void Initialize();
  virtual void Render();
  
  //void MakeTextureCoords();
  //void HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function);
  void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
  void HandlePinch(float scale);
  void HandleLongPress(ivec2 mouse);
private:
  TextureCamera* textureCamera;
  
  
  vec3 rotVals; 
  vec3 transVals; 
  float scaleVal;

};



#endif
