#include "Renderer.hpp"
#include "NSGLView.h"


Renderer* Renderer::instance = NULL;

Renderer* Renderer::GetRenderer() {
  return instance;
}

Renderer::Renderer() {
  printf("Renderer::Renderer()\n");
  
  defaultFBO = 0;
  
  CreateFullScreenRect(); //i.e. can be used to draw a full screen texture from an fbo
  
  instance = this;
}

void Renderer::CreateFullScreenRect() {
  fullScreenRect = new Rectangle(vec3(-1.0, -1.0, 0.0), 2.0, 2.0);
  fullScreenRect->modelview = mat4::Translate(mat4::Identity(), fullScreenRect->GetTranslate());
  fullScreenRect->modelview = mat4::Scale(fullScreenRect->modelview, fullScreenRect->GetScale());
  fullScreenRect->SetIsTransformed(false);
  
  LoadProgram("SingleTexture");
  LoadProgram("BicubicInterpolation");
  
}

set<Geom*>& Renderer::GetGeoms() {
  return geoms;
}

bool Renderer::AddGeom(Geom* _g) {
  geoms.insert(_g);
  return 1; //later make a real test- ie if it's already in there...
}

bool Renderer::RemoveGeom(Geom* _g) {
  //set<Geom*>::iterator it = geoms.find(_g);  
  geoms.erase(geoms.find(_g));
  return 1;  //later make a real test- ie if it was there to be removed...
}


void Renderer::updateGeoms(bool cameraMoved) {
  set<Geom*>::iterator it;

  for (it=GetGeoms().begin(); it!=GetGeoms().end(); it++) {
    Geom* g = (Geom*) *it;
  
    if (cameraMoved || g->IsTransformed()) {
      g->Transform();
    }
  
  }
}
void Renderer::Reshape(int _width, int _height) {
  width = _width;
  height = _height;
  printf("in Renderer::Reshape w/h = %d %d\n", width, height);
  camera->Reshape(width, height);
}

Camera* Renderer::GetCamera() {
  return camera;
}

void Renderer::SetCamera(Camera *_c) {
  camera = _c;
}

void Renderer::SetShiny(float _shiny) {
  shiny = _shiny;
}

void Renderer::CreateRenderBuffer() {
  /*
  glGenRenderbuffers(1, &m_colorRenderbuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, m_colorRenderbuffer);
  */
}

void Renderer::InitializeRenderBuffers() {
  /*
  // Extract width and height.
  glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                               GL_RENDERBUFFER_WIDTH, &width);
  glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                               GL_RENDERBUFFER_HEIGHT, &height);
  
  glGenRenderbuffers(1, &m_depthRenderbuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, m_depthRenderbuffer);
  glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
  
  GLuint framebuffer;
  glGenFramebuffers(1, &framebuffer);
  glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                            GL_RENDERBUFFER, m_colorRenderbuffer);
  glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT,
                            GL_RENDERBUFFER, m_depthRenderbuffer);
  glBindRenderbuffer(GL_RENDERBUFFER, m_colorRenderbuffer);  
  */
  
  /*
   GLuint framebuffer;
   glGenFramebuffers(1, &framebuffer);
   glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
   
   glGenRenderbuffers(1, &m_colorRenderbuffer);
   glBindRenderbuffer(GL_RENDERBUFFER, m_colorRenderbuffer);
   glRenderbufferStorage(GL_RENDERBUFFER, GL_RGBA, width, height);
   glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, m_colorRenderbuffer);
   
   glGenRenderbuffers(1, &m_depthRenderbuffer);
   glBindRenderbuffer(GL_RENDERBUFFER, m_depthRenderbuffer);
   glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, width, height);
   glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, m_depthRenderbuffer);
   
   glBindRenderbuffer(GL_RENDERBUFFER, m_colorRenderbuffer);  
   */
  
}

mat4 ROT_TEST = mat4();

void Renderer::SetCameraRotation(mat4 mvm) {
  
  camera->SetModelView(mvm);
  
}

void Renderer::SetCameraRotation(float pitch, float roll, float yaw) {
  /*
   //vals are in radians (-PI to +PI)
   //Camera* cam = ApplicationHandler::GetApplicationHandler()->GetCamera();
   
   float toDegrees = 180.0 / M_PI;
   
   
   float pD = degrees(pitch); // * toDegrees;
   float pR = roll * toDegrees;
   float pY = yaw * toDegrees;
   
   //printf("{ pitch:%lf, roll:%lf, yaw:%lf }\n", pD, pR, pY);
   printf("{ pitch degree:%lf }\n", pD);
   
   
   //cam->SetRotate(pitch * toDegrees, roll * toDegrees, yaw * toDegrees);
   camera->SetRotate(pD, 0.0, 0.0);
   //cam->RotateY(roll);
   //cam->RotateZ(yaw);
   */
  
}
void Renderer::drawSkybox(Cube* cube, Texture* tex) {
  
  cube->Transform();
  
  glEnable(GL_DEPTH_TEST); 
  glDepthFunc(GL_LESS);
  
  //Need to make sure Skybox is already loaded!!!
  Program* program = GetPrograms()["Skybox"];
  glUseProgram(program->programID);
  
  tex->Bind(GL_TEXTURE0);
  glUniform1i(program->Uniform("Sampler"), 0);
  
  //glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, camera->GetModelView().Pointer());
  glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, cube->GetModelView().Pointer());
  //printf("camera mv:\n");
  //camera->GetModelView().Print();
  //printf("cube mv:\n");
  //cube->GetModelView().Print();
  //printf("\n\n");
  
  glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
  
  
  
  glEnableVertexAttribArray ( program->Attribute("Position") );
  
  int stride = 3 * sizeof(GLfloat); //vertices only (for now)
  glVertexAttribPointer( program->Attribute("Position"), 3, GL_FLOAT, GL_FALSE, stride, &cube->vertices[0] );
  
  glDrawElements( GL_TRIANGLES, cube->GetTriangleIndexCount(), GL_UNSIGNED_SHORT, &cube->triangleIndices[0] );
  
  glDisableVertexAttribArray ( program->Attribute("Position") );
  
  program->Unbind();
}


void Renderer::BindDefaultFrameBuffer() {
  glBindFramebuffer(GL_FRAMEBUFFER, defaultFBO);
  
  
  
  ivec4 vp = camera->viewport;
  glViewport(vp.x, vp.y, vp.z, vp.w);
  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
//  glEnable(GL_BLEND);
//  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
//  glDisable(GL_DEPTH_TEST);
  
}

void Renderer::DrawFullScreenTexture(Texture* t) {
  
  BindDefaultFrameBuffer();
  
  /*
  vector<float>& vvv = fullScreenRect->GetTexCoords();
  
    vvv[0] = post.x + 0.5;
    vvv[i+1] = post.y + 0.5;
    vvv[i+2] = post.z;
    
  }
   */
  
  Program* program = GetPrograms()["BicubicInterpolation"];
  //Program* program = GetPrograms()["SingleTexture"];
  program->Bind(); {
    
    glUniform1f(program->Uniform("fWidth"), width);
    glUniform1f(program->Uniform("fHeight"), height);
    
    
    glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, fullScreenRect->GetModelView().Pointer());
    glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, mat4::Identity().Pointer());
    
    t->Bind(GL_TEXTURE0); {
      
      glUniform1i(program->Uniform("s_tex"), 0);
      fullScreenRect->PassVertices(program, GL_TRIANGLES);
        
    }t->Unbind(GL_TEXTURE0);
  } program->Unbind();
}

bool Renderer::LoadProgram(string programName) {
  //to do - check that the program isn't already loaded!
  
  Program* program = new Program(programName);
  cout << " program ID = " << program->programID << "\n";
  
  GetPrograms().insert(std::pair<string, Program*>(programName, program));
  
  return true; //return true if the shader is available (ie was just loaded or was already loaded
  //return false if we couldn't load the shader!
}

map<string, Program*>& Renderer::GetPrograms() {
  return programs;
}

map<string, Texture*>& Renderer::GetTextures() {
  return textures;
}

map<string, FBO*>& Renderer::GetFbos() {
  return fbos;
}


Texture* Renderer::CreateTexture(string TextureName, Texture* texture) {
  GetTextures().insert(pair<string, Texture*>(TextureName, texture));
  return texture;
}


FBO* Renderer::CreateFBO(string FBOName, Texture* texture) {
  //GetTextures().insert(pair<string, Texture*>("fboATexture", Texture::CreateEmptyTexture(768,1024)));
  FBO* fbo = new FBO(texture);
  GetFbos().insert(pair<string, FBO*>(FBOName, fbo));
  
  return fbo;
}

void Renderer::HandleTouchBegan(ivec2 mouse) {
  printf("renderer not handling TouchBegan\n");
}

void Renderer::HandleTouchMoved(ivec2 prevMouse, ivec2 mouse) {
  printf("renderer not handling TouchMoved\n");
}

void Renderer::HandleTouchEnded(ivec2 mouse) {
  printf("renderer not handling TouchEnded\n");  
}

void Renderer::HandleLongPress(ivec2 mouse) {
  printf("renderer not handling LongPress gesture\n");  
}

void Renderer::HandlePinch(float scale) {
  printf("renderer is not handling Pinch gesture\n");  
}

void Renderer::HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function) {
  printf("renderer is not handling KeyDown\n");    
}


void Renderer::Cleanup() {
 
  printf("Cleanup???\n");
  map<string, Texture*>::iterator iter;   
  for( iter = textures.begin(); iter != textures.end(); iter++ ) {
    cout << "cleaning up Texture " << iter->first << "\n";
    
    Texture* t = iter->second;
    GLuint texid = t->texID;
    glDeleteTextures(1, &texid); 
  }
 
  glFinish();
 
}









