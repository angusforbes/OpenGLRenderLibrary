//#include "ApplicationHandler.hpp"



#include "Program.hpp"
#include "Cube.hpp"
#include "Texture.hpp"
#include "Rectangle.hpp"
#include "FBO.hpp"
#include <map>
#include <vector>
#include <set>

#include "Camera.hpp"
#include "Vector.hpp"
#include "Matrix.hpp"
#include "FontAtlas.hpp"

#ifndef RENDERER_H
#define RENDERER_H


class Renderer {
public:
  static Renderer* GetRenderer();
  
  
  Renderer(); 
  //Renderer();
  
  virtual void Initialize() = 0;
  virtual void Render() = 0;

  FontAtlas* CurrentFont;
  void Text(float pen_x, float pen_y, string text, vec4 color );
  void Text(float pen_x, float pen_y, string text, vec4 color, bool usePixel );
  void Text(FontAtlas* font, float pen_x, float pen_y, string text, vec4 color );
  void Text(FontAtlas* font, float pen_x, float pen_y, string text, vec4 color, bool usePixel );
  
  FontAtlas* GetFont(string font);
  
  int width, height;
  void CreateRenderBuffer();
  void InitializeRenderBuffers();
  
  void Reshape(int width, int height);
  //void initializeRenderBuffers(GLuint* m_colorRenderbuffer, GLuint* m_depthRenderbuffer);
 
  void drawSkybox(Cube* cube, Texture* tex);
  
  map<string, Program*>& GetPrograms();
  map<string, Texture*>& GetTextures();
  map<string, FBO*>& GetFbos();
  set<Geom*>& GetGeoms();
  bool AddGeom(Geom* _g);
  bool RemoveGeom(Geom* _g);
  
  void SetCameraRotation(float pitch, float roll, float yaw); 
  void SetCameraRotation(mat4 _mvm);
  Camera* GetCamera();
  void SetCamera(Camera* _c);
  
  virtual void HandleTouchBegan(ivec2 mouse);
  virtual void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
  virtual void HandleTouchEnded(ivec2 mouse);
  virtual void HandleLongPress(ivec2 mouse);
  virtual void HandlePinch(float scale);
  
  virtual void HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function);
  
  void Cleanup();

  bool isReady;
  
protected: 
  FBO* CreateFBO(string FBOName, Texture* texture);
  Texture* CreateTexture(string TextureName, Texture* texture);

  set<Geom*> geoms;
  
  void updateGeoms(bool cameraMoved);
  
  Program* LoadProgram(string programName);
  Program* GetProgram(string programName);
  
  bool isRendering;
  GLuint m_colorRenderbuffer;
  GLuint m_depthRenderbuffer;
  
  Camera* camera;
  //void* view; //needs to be cast to GLView* to be used!
  

  Rectangle* fullScreenRect;
  GLuint defaultFBO;
  void DrawFullScreenTexture(Texture* t);
  void BindDefaultFrameBuffer();
  
  void CreateFullScreenRect();

  
private:
  
  map<string, Program*> programs;
  map<string, Texture*> textures;
  map<string, FBO*> fbos;
  map<string, FontAtlas*> fonts;

 static Renderer* instance;
  
  
  //ApplicationHandler* m_appHandler;

};
#endif
