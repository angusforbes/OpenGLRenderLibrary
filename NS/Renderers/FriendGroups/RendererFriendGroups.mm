
//#include <iostream>
#include "RendererFriendGroups.hpp"
#include "Utils.hpp" 
#include "NSGLView.h"
#include "AppDelegate.h"
#include "GratingFunctions.hpp"
//#include "arial-16.h"
//#include "Vera-36.h" 
#include "FontAtlas.hpp"

//#import <Carbon/Carbon.h> //needed for key event codes


RendererFriendGroups::RendererFriendGroups() : Renderer() {
   EXPERIMENT_NUMBER=4; //15;  
  BACKGROUND_COLOR=vec4(100,255);
  //vec4 BACKGROUND_COLOR=vec4(128,128,128,255);
  //vec4 BACKGROUND_COLOR=vec4(255,255,255,255);
  
  I_AM_READY  = false;
}

void RendererFriendGroups::Initialize() {
  SetCamera(new Camera(ivec4(0, 0, width, height)));
  CreateFullScreenRect();
   fullScreenRect->Transform();
  BindDefaultFrameBuffer();
  
  /*
  glGenTextures( 1, &FONT_TEX_ID );
  glBindTexture( GL_TEXTURE_2D, FONT_TEX_ID );
  glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP );
  glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP );
  glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
  glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
  glTexImage2D( GL_TEXTURE_2D, 0, GL_ALPHA, font.tex_width, font.tex_height,
               0, GL_ALPHA, GL_UNSIGNED_BYTE, font.tex_data );
  glBindTexture( GL_TEXTURE_2D, FONT_TEX_ID );
  */
  BACKGROUND_COLOR = BACKGROUND_COLOR/255.0;
    
 // ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  
  //exit(0);
  I_AM_READY = true;
}




void RendererFriendGroups::Render() { 
  
  if (!I_AM_READY) { printf("not ready!\n"); return; }
  
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
  
  BindDefaultFrameBuffer();
  
 // glBindTexture( GL_TEXTURE_2D, FONT_TEX_ID );
  

  //GetFont("CMUSerifUprightItalic128")->Text(0.0, 0.5, "12345", vec4(1.0,0.0,0.0,0.5));
  
  FontAtlas* font = GetFont("Univers128");
  font->Bind(); {
    Text(0, 100, "abcdefægh", vec4(1.0,1.0,0.0,0.5), true );
  } font->Unbind();
  
  font = GetFont("CMUSerifUprightItalic60");
  font->Bind(); {
    Text(0, 100, "abcdefægh", vec4(1.0,1.0,0.0,0.5), true );
  } font->Unbind();
  
  if (1 == 1) return;
  
  
  Program* program = GetProgram("GratingPatch"); 
  
  glClearColor(BACKGROUND_COLOR.x, BACKGROUND_COLOR.y, BACKGROUND_COLOR.z, BACKGROUND_COLOR.w);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  //glBlendFunc(GL_ONE,GL_ONE);
  
  
  int i;
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
    
    RectGrating* g = (RectGrating*) *it;
    g->phase += g->phaseSpeed;
    GratingFunctions::DrawGrating(NULL, program, g);
  }
  
  
  if (EXPERIMENT_NUMBER != 99) {
    
  // BindDefaultFrameBuffer();
  //textRect->Transform();
  Program* p1 = GetPrograms()["SingleTexture"]; 
  if (p1 == NULL) {
    printf("WHA???\n");
    exit(0);
  }
  p1->Bind(); {
    //printf("the modelview!\n");
    //textRect->GetModelView().Print();
      glUniformMatrix4fv(p1->Uniform("Modelview"), 1, 0, textRect->GetModelView().Pointer());
      glUniformMatrix4fv(p1->Uniform("Projection"), 1, 0, mat4::Identity().Pointer());
      
      instructionsTex->Bind(GL_TEXTURE0); {
        glUniform1i(p1->Uniform("s_tex"), 0);
        
        textRect->PassVertices(p1, GL_TRIANGLES);
        
      } instructionsTex->Unbind(GL_TEXTURE0);
    
  } p1->Unbind();
  
  
  selectRect->phase += selectRect->phaseSpeed;
  GratingFunctions::DrawGrating(NULL, program, selectRect);
  }
}

bool RendererFriendGroups::CheckIfAnyLeftOfKind(int kind) {
  
  RectGrating* rg = NULL;
  int howMany = 0;
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(); it!=GetGeoms().end(); it++) {
    RectGrating* g = (RectGrating*) *it;
    
    if (g->choose == true) {
      return true;
      
    }
  }
  
  
      return false;
  
}

void RendererFriendGroups::HandleTouchBegan(ivec2 mouse) {
  
  Geom* pg;
  bool isHit = false;
  
  int i;
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
    RectGrating* g = (RectGrating*) *it;
    
    if (g->choose == true) {
      vec3 LL = mat4::Project(vec3(0.0,0.0,0.0), g->modelview, camera->projection, camera->viewport);
      vec3 UR = mat4::Project(vec3(1.0,1.0,0.0), g->modelview, camera->projection, camera->viewport);
      
      if (mouse.x > LL.x && mouse.x < UR.x && mouse.y > LL.y && mouse.y < UR.y) {
        //mouse.Print();
        //printf("hit!\n");
        isHit = true;
        pg = g;
        break;
      }
    }
  }
  
  if (isHit == true) {
    ((RectGrating*)(pg))->isSelected = true;
    ((RectGrating*)(pg))->choose = false;
    //RemoveGeom(pg);
  }
  if (!CheckIfAnyLeftOfKind(0)) {
    
    printf("total time : %f\n", ResourceHandler::GetResourceHandler()->GetElapsedTime());
    
    exit(0);
  }
  
}

