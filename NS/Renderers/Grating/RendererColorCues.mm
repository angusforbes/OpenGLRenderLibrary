

#include <iostream>
#include "RendererColorCues.hpp"
#include "Utils.hpp" 
#include "NSGLView.h"
#include "AppDelegate.h"
#include "GratingFunctions.hpp"
//#import <Carbon/Carbon.h> //needed for key event codes


RendererColorCues::RendererColorCues() : Renderer() {
}

void RendererColorCues::Initialize() {
  
  GetPrograms().insert(std::pair<string, Program*>("GratingPatch", new Program("GratingPatch")));
  GetPrograms().insert(std::pair<string, Program*>("OutputTexture", new Program("OutputTexture")));
  
  
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
  Texture* circleMask = rh->CreateTextureFromImageFile("circle4.png");
  
  
  
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
    if ( i < 5 ) {
      which = 2;
    } else if ( i < 190 ) {
      which = 1;
    }else {
      which = 0;
    }
    
    RectGrating* r;
    vec4 rcolor = GratingFunctions::ChooseColor();
    
    switch(which) {
        
      case 0: //pulsing
        r = new RectGrating(99, circleMask, rcolor, rcolor, 0.01, 0.0, 0.0, Utils::randomFloatBetween(0.05, 0.05) );
        break;
      case 1: //not pulsing
        r = new RectGrating(99, circleMask, rcolor, rcolor, 0.01, 0.5, 0.0,  0.0 );
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

