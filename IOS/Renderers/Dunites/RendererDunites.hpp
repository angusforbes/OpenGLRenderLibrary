#include "Renderer.hpp" 
#include "TextureCamera.hpp"
#include "IOSGLView.h"


#ifndef OpenGLRenderLibraryNS_RendererDunites_hpp
#define OpenGLRenderLibraryNS_RendererDunites_hpp

class RendererDunites : public Renderer {
  
public:
  int cols;
  int rows;
  int slices;
  int textures;
  
  int textureWidth;
  int textureHeight;
  
  Texture** naturalTextures;
  
  Texture* testTex;
  Texture* compressedTex;
  Texture* uncompressedTex;
  Texture* lookupTex;
  
  RendererDunites();
  
  virtual void Initialize();
  virtual void Render();
  
  //void MakeTextureCoords();
  //void HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function);
  void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
  void HandlePinchEnded();
  void HandlePinch(float scale);
  void HandleLongPress(ivec2 mouse);
private:
  
  mat4 MakeTextureMatrix();
  TextureCamera* textureCamera;
  
  
  vec3 rotVals; 
  vec3 transVals; 
  float scaleVal;

};



#endif
