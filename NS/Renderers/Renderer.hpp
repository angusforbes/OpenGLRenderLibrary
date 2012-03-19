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
  //Renderer();
  
  virtual void Initialize() = 0;
  virtual void Render() = 0;

  int width, height;
  void CreateRenderBuffer();
  void InitializeRenderBuffers();
  
  void Reshape(int width, int height);
  //void initializeRenderBuffers(GLuint* m_colorRenderbuffer, GLuint* m_depthRenderbuffer);
 
  void drawSkybox(Cube* cube, Texture* tex);
 

  //this should be somewhere else! (ie specific to a particular renderer, so should be in 
  //the chapters ApplicatonHandler! (and also initialized there!)
  int prevMode; //= -1;
  int MAX_BOUNCES; // = 10;
  float lightY;
  float shiny;
  void SetShiny(float shiny);
  
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
  map<string, Program*> programs;
  map<string, Texture*> textures;
  map<string, FBO*> fbos;
  set<Geom*> geoms;
  
  void updateGeoms(bool cameraMoved);
  bool LoadProgram(string programName);
  
  bool isRendering;
  GLuint m_colorRenderbuffer;
  GLuint m_depthRenderbuffer;
  
  Camera* camera;
  //void* view; //needs to be cast to GLView* to be used!
  
  
protected:
  
  Rectangle* fullScreenRect;
  GLuint defaultFBO;
  void DrawFullScreenTexture(Texture* t);
  void BindDefaultFrameBuffer();
  
  
private:
  void CreateFullScreenRect();
  
 static Renderer* instance;
  
  
  //ApplicationHandler* m_appHandler;

};
#endif
