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


#ifndef RENDERER_H
#define RENDERER_H



class Renderer {
public:
  static Renderer* GetRenderer();
  
  Renderer(); 
  virtual void Initialize() = 0;
  virtual void Render() = 0;
  
  /* 
   isReady is set only after IOS view is completely loaded (in the ViewController). 
   Problems occur is we try to render before the view is loaded.
   */
  bool isReady; 
  
  /* 
   isRendering is set right before and right after Render is called from the GLView. Not sure if this is needed.
  */
  bool isRendering;
  
  /* 
   Programmatically add UI elements by overriding the AddUI method.
   */
  virtual void AddUI();
  
  int width, height;
  void CreateRenderBuffer();
  void InitializeRenderBuffers();
  
  void Reshape(int width, int height);
  
  map<string, Program*>& GetPrograms();
  map<string, Texture*>& GetTextures();
  map<string, FBO*>& GetFbos();
  set<Geom*>& GetGeoms();
  bool AddGeom(Geom* _g);
  bool RemoveGeom(Geom* _g);
  
  void SetGyroscopeMatrix(mat4 _mvm);
  
  Camera* GetCamera();
  void SetCamera(Camera* _c);
  
  virtual void HandleTouchBegan(ivec2 mouse);
  virtual void HandleTouchMoved(ivec2 prevMouse, ivec2 mouse);
  virtual void HandleTouchEnded(ivec2 mouse);
  virtual void HandleLongPress(ivec2 mouse);
  virtual void HandlePinch(float scale);
  
  virtual void HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function);
  
  void Cleanup();

  
protected: 
  FBO* CreateFBO(string FBOName, Texture* texture);
  Texture* CreateTexture(string TextureName, Texture* texture);

  map<string, Program*> programs;
  map<string, Texture*> textures;
  map<string, FBO*> fbos;
  set<Geom*> geoms;
  
  void updateGeoms(bool cameraMoved);
  bool LoadProgram(string programName);
  
 
  GLuint m_colorRenderbuffer;
  GLuint m_depthRenderbuffer;
  
  Camera* camera;
  mat4 gyroscopeMatrix;
  
  Rectangle* fullScreenRect;
  GLuint defaultFBO;
  void DrawFullScreenTexture(Texture* t);
  void BindDefaultFrameBuffer();
  void CreateFullScreenRect();
  
private:
  
  
 static Renderer* instance;
  

};
#endif
