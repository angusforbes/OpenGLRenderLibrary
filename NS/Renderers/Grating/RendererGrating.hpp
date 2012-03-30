#include "Renderer.hpp" 
#include "Rectangle.hpp" 
#include "RectGrating.hpp" 
#include "Circle.hpp" 
#include "TextureCamera.hpp"

#ifndef RENDERER_GRATING_hpp
#define RENDERER_GRATING_hpp

class RendererGrating : public Renderer {
  
  
public:
  
  vec4 colorA;
  vec4 backgroundColorA;
  vec4 colorB;
  vec4 backgroundColorB;
  vec4 colorC;
  vec4 backgroundColorC;
  vec4 colorD;
  vec4 backgroundColorD;
  vec4 colorE;
  vec4 backgroundColorE;
  
  float freq1;
  float phase1;
  float theta1;
  float speed1;
  
  float freq2;
  float phase2;
  float theta2;
  float speed2;
  
  float freq3;
  float phase3;
  float theta3;
  float speed3;
  
  float freq4;
  float phase4;
  float theta4;
  float speed4;
  
  float freq5;
  float phase5;
  float theta5;
  float speed5;
  
  
  
  RendererGrating();
  
  virtual void Initialize();
  virtual void Render();
  
  bool CheckIfAnyLeftOfKind(int ofKind);
  void HandleTouchBegan(ivec2 mouse);
 private:
  
  //void DrawGrating(FBO* fbo, float freq, float phase, float theta, vec4 *color, vec4 *backgroundColor, Texture* mask, Geom* geom);
  void DrawGrating(FBO* fbo, RectGrating* geom);
  void BlendTextures(FBO* fbo, Texture* t1, Texture* t2);
  Circle* c1;
  RectGrating* r1;
  
  RectGrating* r1s[100];
  RectGrating* r2s[10];
  RectGrating* r3s[10];

};


#endif

