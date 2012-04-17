#include "Renderer.hpp" 
#include "Rectangle.hpp" 
#include "RectGrating.hpp" 
#include "Circle.hpp" 
#include "TextureCamera.hpp"
#include "Texture.hpp" 

#ifndef RENDERER_FRIEND_GROUPS_hpp
#define RENDERER_FRIEND_GROUPS_hpp

class RendererFriendGroups : public Renderer {
  
  
public:
  
  //FontAtlas* font4;
  
  GLuint FONT_TEX_ID;
 // void PrintAt( float pen_x, float pen_y, wchar_t *text, vec4 color );
  
  int EXPERIMENT_NUMBER; //15;  
  vec4 BACKGROUND_COLOR;
  //vec4 BACKGROUND_COLOR=vec4(128,128,128,255);
  //vec4 BACKGROUND_COLOR=vec4(255,255,255,255);
  
  bool I_AM_READY;

  
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
  
   
  RendererFriendGroups();
  
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

