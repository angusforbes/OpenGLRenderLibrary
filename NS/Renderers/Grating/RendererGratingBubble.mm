

#include <iostream>
#include "RendererGratingBubble.hpp"
#include "Utils.hpp" 
#include "NSGLView.h"
#include "AppDelegate.h"
#include "GratingFunctions.hpp"
//#import <Carbon/Carbon.h> //needed for key event codes




RendererGratingBubble::RendererGratingBubble() : Renderer() {
}

void RendererGratingBubble::Initialize() {
  
 
  
  vec4 colorLG = vec4(1.0, 1.0);
  vec4 colorDG = vec4(0.0, 1.0);
  vec4 colorMG = vec4(0.5, 1.0);
  
  vec4 color1 = vec4(141/255.0, 211/255.0, 199/255.0, 1.0);
  vec4 color2 = vec4(255/255.0, 255/255.0, 179/255.0, 1.0);
  vec4 color3 = vec4(190/255.0, 186/255.0, 218/255.0, 1.0);
  vec4 color4 = vec4(251/255.0, 128/255.0, 114/255.0, 1.0);
  vec4 color5 = vec4(56/255.0, 108/255.0, 176/255.0, 1.0);
  vec4 color6 = vec4(253/255.0, 180/255.0, 98/255.0, 1.0);
  vec4 color7 = vec4(179/255.0, 222/255.0, 105/255.0,1.0);
  vec4 color8 = vec4(252/255.0, 205/255.0, 229/255.0, 1.0);
  
  
  colorA = colorMG;
  colorB = colorMG;
  colorC = colorMG;
  colorD = vec4(0.7, 0.5, 0.5,1.0); //color4;
  colorE = color5;
  backgroundColorA = colorDG;
  backgroundColorB = colorDG;
  backgroundColorC = colorDG;
  backgroundColorD = colorDG;
  backgroundColorE = colorDG;
  

  SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  Texture* tex1 = rh->CreateTextureFromImageFile("trans1.png");
  Texture* tex2 = rh->CreateTextureFromImageFile("trans2.png");
  Texture* tex3 = rh->CreateTextureFromImageFile("trans3.png");
  Texture* tex4 = rh->CreateTextureFromImageFile("trans4.png");
  Texture* tex5 = rh->CreateTextureFromImageFile("transrect5.png");
  
  int div = 1;
  CreateFBO("fboA", Texture::CreateEmptyTexture(1024/div,1024/div));
  CreateFBO("fboB", Texture::CreateEmptyTexture(1024/div,1024/div));
  CreateFBO("fboC", Texture::CreateEmptyTexture(1024/div,1024/div));
  CreateFBO("fboD", Texture::CreateEmptyTexture(1024/div,1024/div));
  CreateFBO("fboE", Texture::CreateEmptyTexture(1024/div,1024/div));
  
  
  RectGrating* fs1 = new RectGrating(7, tex1, color8, vec4(0.0,1.0), 100.0, 0.0, 45.0, 0.0,
                                     1, 0.95);
  fs1->SetTranslate(vec3(-0.5, -0.5, 0.0));
  fs1->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
  fs1->SetScale(vec3(2.0, 2.0, 1.0));
  fs1->Transform();
  RectGrating* fs2 = new RectGrating(7, tex3, color7, vec4(0.0,1.0), 70.0, 0.0, 0.0, 0.2,
                                     1, 0.95);
  fs2->SetTranslate(vec3(-0.5, -0.5, 0.0));
  fs2->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
  fs2->SetScale(vec3(2.0, 2.0, 1.0));
  fs2->Transform();
  RectGrating* fs3 = new RectGrating(7, tex3, color7, vec4(0.0,1.0), 70.0, 0.0, 90.0, 0.10,
                                     1, 0.95);
  fs3->SetTranslate(vec3(-0.5, -0.5, 0.0));
  fs3->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
  fs3->SetScale(vec3(2.0, 2.0, 1.0));
  fs3->Transform();
  RectGrating* fs4 = new RectGrating(7, tex4, color2, vec4(0.0,1.0), 100.0, 0.0, 135.0, 0.0,
                                     1, 0.95);
  fs4->SetTranslate(vec3(-0.5, -0.5, 0.0));
  fs4->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
  fs4->SetScale(vec3(2.0, 2.0, 1.0));
  fs4->Transform();
  
  AddGeom(fs1);
  AddGeom(fs2);
  AddGeom(fs3);
  AddGeom(fs4);
  
  GetPrograms().insert(std::pair<string, Program*>("GratingPatch", new Program("GratingPatch")));
  GetPrograms().insert(std::pair<string, Program*>("OutputTexture", new Program("OutputTexture")));
  
  CreateFullScreenRect();
  BindDefaultFrameBuffer();
}



void RendererGratingBubble::Render() { 
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
  
  Program* gratingProgram = GetPrograms()["GratingPatch"]; 
  
  int i;
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
    RectGrating* g = (RectGrating*) *it;
    
    g->phase += g->phaseSpeed;
    
    FBO* fbo;
    if (i == 0) {
      fbo = GetFbos()["fboA"];
    } else if (i == 1) {
      fbo = GetFbos()["fboB"];
    } else if (i == 2) {
      fbo = GetFbos()["fboC"];
    } else if (i == 3) {
      fbo = GetFbos()["fboD"];
    }
    
    GratingFunctions::DrawGrating(fbo, gratingProgram, g);
  }
  
  BindDefaultFrameBuffer();         
  
  
  Texture* t0 = GetFbos()["fboA"]->texture;
  Texture* t1 = GetFbos()["fboB"]->texture;
  Texture* t2 = GetFbos()["fboC"]->texture;
  Texture* t3 = GetFbos()["fboD"]->texture;
  //  Texture* t4 = GetFbos()["fboE"]->texture;
  
  
  Program* program = GetPrograms()["OutputTexture"]; 
  program->Bind(); {
    
    glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, fullScreenRect->GetModelView().Pointer());
    glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, mat4::Identity().Pointer());
    
    t0->Bind(GL_TEXTURE0); 
    glUniform1i(program->Uniform("tex0"), 0);
    t1->Bind(GL_TEXTURE1); 
    glUniform1i(program->Uniform("tex1"), 1);
    t2->Bind(GL_TEXTURE2); 
    glUniform1i(program->Uniform("tex2"), 2);
    t3->Bind(GL_TEXTURE3); 
    glUniform1i(program->Uniform("tex3"), 3);
    //    t4->Bind(GL_TEXTURE4); 
    //    glUniform1i(program->Uniform("tex4"), 4);
    
    
    fullScreenRect->PassVertices(program, GL_TRIANGLES);
    
    t0->Unbind(GL_TEXTURE0); 
    t1->Unbind(GL_TEXTURE1); 
    t2->Unbind(GL_TEXTURE2); 
    t3->Unbind(GL_TEXTURE3); 
    //    t4->Unbind(GL_TEXTURE4); 
    
  } program->Unbind();
}

bool RendererGratingBubble::CheckIfAnyLeftOfKind(int kind) {
  
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(); it!=GetGeoms().end(); it++) {
    RectGrating* g = (RectGrating*) *it;
    
    if (g->kind == 0) {
      return true;
    }
  }
  
  return false;
}

void RendererGratingBubble::HandleTouchBegan(ivec2 mouse) {
  
  Geom* pg;
  bool isHit = false;
  
  int i;
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
    RectGrating* g = (RectGrating*) *it;
    
    if (g->kind == 0) {
      vec3 LL = mat4::Project(vec3(0.0,0.0,0.0), g->modelview, camera->projection, camera->viewport);
      vec3 UR = mat4::Project(vec3(1.0,1.0,0.0), g->modelview, camera->projection, camera->viewport);
      
      if (mouse.x > LL.x && mouse.x < UR.x && mouse.y > LL.y && mouse.y < UR.y) {
        mouse.Print();
        printf("hit!\n");
        isHit = true;
        pg = g;
        break;
      }
    }
  }
  
  if (isHit == true) {
    RemoveGeom(pg);
  }
  if (!CheckIfAnyLeftOfKind(0)) {
    
    printf("total time : %f\n", ResourceHandler::GetResourceHandler()->GetElapsedTime());
    
    exit(0);
  }
  
}

