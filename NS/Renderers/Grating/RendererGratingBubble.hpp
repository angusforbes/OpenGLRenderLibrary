#include "Renderer.hpp" 
#include "Rectangle.hpp" 
#include "RectGrating.hpp" 
#include "Circle.hpp" 
#include "TextureCamera.hpp"
#include "GratingFunctions.hpp"

#ifndef RENDERER_GRATING_BUBBLE_hpp
#define RENDERER_GRATING_BUBBLE_hpp

class RendererGratingBubble : public Renderer {
  
  
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
  
   
  TextureCamera* tc;
  
  RendererGratingBubble();
  
  virtual void Initialize();
  virtual void Render();
  
  bool CheckIfAnyLeftOfKind(int ofKind);
  void HandleTouchBegan(ivec2 mouse);
 private:
  
  
};


#endif

