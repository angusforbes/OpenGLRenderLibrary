#include "Renderer.hpp" 
#include "Rectangle.hpp" 
#include "TextureCamera.hpp"

#ifndef RENDERER_GRATING_hpp
#define RENDERER_GRATING_hpp

class RendererGrating : public Renderer {
  
  
public:
  
  vec4 color1;
  vec4 backgroundColor1;
  vec4 color2;
  vec4 backgroundColor2;
  
  float freq1;
  float freq2;
  float phase1;
  float phase2;
  float theta1;
  float theta2;

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
  void DrawGrating(FBO* fbo, float freq, float phase, float theta, vec4 *color, vec4 *backgroundColor);
  void BlendTextures(FBO* fbo, Texture* t1, Texture* t2);

};


#endif

