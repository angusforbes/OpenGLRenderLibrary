#include "Renderer.hpp" 
#include "Rectangle.hpp" 
#include "RectGrating.hpp" 
#include "Circle.hpp" 
#include "TextureCamera.hpp"
#include "Texture.hpp" 

#ifndef RENDERER_COLOR_CUES_hpp
#define RENDERER_COLOR_CUES_hpp

class RendererColorCues : public Renderer {
  
  
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
  
   
  RendererColorCues();
  
  virtual void Initialize();
  virtual void Render();
  
  void InitializeImagesOnly();
  
  bool CheckIfAnyLeftOfKind(int ofKind);
  void HandleTouchBegan(ivec2 mouse);
private:
  
  RectGrating* selectRect;
  
  Rectangle* textRect;
  Texture* instructionsTex;
};


#endif

