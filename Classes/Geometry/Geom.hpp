


#include "ModelView.hpp"
#include "Mesh.hpp"
#include <vector>



#ifndef OpenGLRenderLibraryNS_Geom_hpp
#define OpenGLRenderLibraryNS_Geom_hpp

class Camera;



class Geom : public ModelView, public Mesh {
  
public:
  
  Geom();
  
  
  vector<Geom*>& GetGeoms();
  
  vector<Geom*> geoms;
  
  Camera* root;
  Geom* parent;
  
  bool AddGeom(Geom* _g);
  bool RemoveGeom(Geom* _g);
  
  void SetColor(vec4 _Color);
  void SetColor(float r, float g, float b, float a);
  void SetColor(float r, float g, float b);
  vec4 GetColor();
  
  
  bool IsSelectable;
  
  
  Program* GetProgram(string _p); //convenienve method to get items from Renderer
  
  virtual void Draw();
  virtual bool ContainsWindowPoint(ivec2 windowPt);

  //absolute text coords
  virtual void Text(float pen_x, float pen_y, string text, vec4 color ); //default font, clip space
  virtual void Text(float pen_x, float pen_y, string text, vec4 color, bool usePixel ); //default font, "usePixel = true" = pixel space, else clip space
  virtual void Text(FontAtlas* font, float pen_x, float pen_y, string text, vec4 color ); //clip space
  virtual void Text(FontAtlas* font, float pen_x, float pen_y, string text, vec4 color, bool usePixel ); //"usePixel = true" = pixel space, else clip space
  //relative text coords
  virtual void Text(vec3 offsetPt, string text, vec4 color); //default font, point is relative to current object modelview
  
  virtual void HandleTouchBegan(ivec2 mouse);
  virtual void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
  virtual void HandleTouchEnded(ivec2 mouse);
  virtual void HandleLongPress(ivec2 mouse);
  virtual void HandlePinch(float scale);
  virtual void HandlePinchEnded();
  
  //Geom(vec3 translate, float width, float height);
  
  
  //from ModelView
  virtual void Transform();
  
  //from Mesh
//  virtual void GenerateLineIndices();
//  virtual void GenerateTriangleIndices();
//  virtual int GetVertexCount() ;
//  virtual int GetLineIndexCount() ;
//  virtual int GetTriangleIndexCount() ;
  
  
protected:
  vec4 Color;
};

#endif
