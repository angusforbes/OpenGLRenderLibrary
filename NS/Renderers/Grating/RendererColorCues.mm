

#include <iostream>
#include "RendererColorCues.hpp"
#include "Utils.hpp" 
#include "NSGLView.h"
#include "AppDelegate.h"
#include "GratingFunctions.hpp"
//#import <Carbon/Carbon.h> //needed for key event codes


//1 = 3 colors
//2 = 2 colors, 1 texture
//3 = 1 color, 2 texture
//4 = 3 textures
int EXPERIMENT_NUMBER=1;  

RendererColorCues::RendererColorCues() : Renderer() {
}

void RendererColorCues::Initialize() {
  
  GetPrograms().insert(std::pair<string, Program*>("GratingPatch", new Program("GratingPatch")));
  GetPrograms().insert(std::pair<string, Program*>("OutputTexture", new Program("OutputTexture")));
  
  
  vec4 colorLG = vec4(1.0, 1.0);
  vec4 colorDG = vec4(0.0, 1.0);
  vec4 colorMG = vec4(0.5, 1.0);
  
  SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  Texture* circleMask = rh->CreateTextureFromImageFile("circle4.png");
  
  vec4 rcolor1 = GratingFunctions::ChooseColor();
  vec4 rcolor2 = GratingFunctions::ChooseColor();
  vec4 rcolor3 = GratingFunctions::ChooseColor();
  vec4 rcolor4 = GratingFunctions::ChooseColor();
  vec4 rcolor5 = GratingFunctions::ChooseColor();
  vec4 rcolor6 = GratingFunctions::ChooseColor();
  
  for (int i = 0; i < 200; i++) {
    
    float ux = Utils::randomFloatBetween(-0.8 - 0.5, 0.8 - 0.5);
    float uy = Utils::randomFloatBetween(-0.8 - 0.5, 0.8 - 0.5);
    
    bool passed = true;
    
    //naive check
    for (int ii = 0; ii < i; ii++) {
      float dist = vec3::Distance(r1s[ii]->GetTranslate(), vec3(ux, uy, 0.0));
      //printf("dist = %f\n", dist);
      if (dist < 0.08) {
        passed = false;
        break;
      }
    }
    
    if (passed == false) {
      printf("too close!\n");
      i--;
      continue;
    }
    
    
    int which;
    
    switch (EXPERIMENT_NUMBER) {
      case 1:
        //EXPERIMENT 1 : 3 pulsing colors
        
        if ( i < 3 ) {
          which = 1;
        } else if ( i < 6 ) {
          which = 2;
        } else if ( i < 11 ) {
          which = 3;
        } else {
          which = 0;
        }
        break;
        
      case 2:
        
        //EXPERIMENT 2 : 2 pulsing colors, 1 moving texture
        
        if ( i < 3 ) {
          which = 1;
        } else if ( i < 6 ) {
          which = 4;
        } else if ( i < 11 ) {
          which = 3;
        } else {
          which = 0;
        }
        break;
      case 3:
        
        
        
        //EXPERIMENT 3 : 1 pulsing color, 2 moving textures
        if ( i < 3 ) {
          which = 1;
        } else if ( i < 6 ) {
          which = 4;
        } else if ( i < 11 ) {
          which = 5;
        } else {
          which = 0;
        }
        break;
        
        
      case 4:
        
        //EXPERIMENT 4 : 3 moving textures
        if ( i < 3 ) {
          which = 6;
        } else if ( i < 6 ) {
          which = 4;
        } else if ( i < 11 ) {
          which = 5;
        } else {
          which = 0;
        }
        break;
        
      default:
        printf("ERROR, experiment number not defined\n");
        exit(0);
    }
    
    RectGrating* r;
    vec4 rcolor = GratingFunctions::ChooseColor();
    
    switch(which) {
        
      case 0: //not pulsing
        r = new RectGrating(99, circleMask, rcolor, rcolor, 0.01, 0.5, 0.0,  0.0 );
        break;
        
      case 1: //pulsing A
        r = new RectGrating(99, circleMask, rcolor1, rcolor1, 0.0, 0.0, 0.0, Utils::randomFloatBetween(0.05, 0.05) );
        break;
      case 2: //pulsing B
        r = new RectGrating(99, circleMask, rcolor2, rcolor2, 0.75, 0.0, 0.0, Utils::randomFloatBetween(0.05, 0.05) );
        break;
      case 3: //pulsing C
        r = new RectGrating(99, circleMask, rcolor3, rcolor3, 1.5, 0.0, 0.0, Utils::randomFloatBetween(0.05, 0.05) );
        break;
      case 4: //moving 1
        r = new RectGrating(0, circleMask, rcolor4, colorDG, 5.0, 0.0, 0.0, 0.2 );
        break;
      case 5: //moving 2
        r = new RectGrating(0, circleMask, rcolor5, colorDG, 6.0, 0.0, 90.0, 0.15 );
        break;
      case 6: //moving 3
        r = new RectGrating(0, circleMask, rcolor6, colorDG, 4.0, 0.0, 45.0, 0.3 );
        break;
        
      default: //moving
        r = new RectGrating(0, circleMask, rcolor, colorDG, 5.0, 0.0, 0.0, 0.5 );
        break;
        
        
        
    }
    
    r->SetTranslate(vec3(ux, uy, 0.0));
    r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
    r->SetScale(vec3(0.05, 0.05 * camera->aspect, 1.0));
    
    AddGeom(r);
    r->Transform();
    r1s[i] = r;
  }
  
  
  
  CreateFullScreenRect();
  BindDefaultFrameBuffer();
}



void RendererColorCues::Render() { 
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
  
  BindDefaultFrameBuffer();
  
  Program* program = GetPrograms()["GratingPatch"]; 
  
  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  
  
  int i;
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
    
    RectGrating* g = (RectGrating*) *it;
    g->phase += g->phaseSpeed;
    GratingFunctions::DrawGrating(NULL, program, g);
  }
}

bool RendererColorCues::CheckIfAnyLeftOfKind(int kind) {
  
  
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(); it!=GetGeoms().end(); it++) {
    RectGrating* g = (RectGrating*) *it;
    
    if (g->kind == 0) {
      return true;
    }
  }
  
  return false;
}

void RendererColorCues::HandleTouchBegan(ivec2 mouse) {
  
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

