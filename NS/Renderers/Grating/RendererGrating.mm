

#include <iostream>
#include "RendererGrating.hpp"
#include "Utils.hpp" 
#include "NSGLView.h"
#include "AppDelegate.h"
#include "GratingFunctions.hpp"
//#import <Carbon/Carbon.h> //needed for key event codes


RendererGrating::RendererGrating() : Renderer() {
}

void RendererGrating::Initialize() {
  
  freq1 = 300.0;
  theta1 = 0.0;
  phase1 = 0.0;
  speed1 = .0;
  
  freq2 = 300.0;
  theta2 = 90.0;
  phase2 = 0.0;
  speed2 = .0;
  
  freq3 = 200.0;
  theta3 = 45.0;
  phase3 = 0.0;
  speed3 = .3;
  
  freq4 = 200.0;
  theta4 = 135.0;
  phase4 = 0.0;
  speed4 = .0;
  
  freq5 = 10.0;
  theta5 = 90.0;
  phase5 = 0.0;
  speed5 = .1;
  
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
 
  
   
  for (int i = 0; i < 50; i++) {
    
    float ux = Utils::randomFloatBetween(-0.8 - 0.5, 0.8 - 0.5);
    float uy = Utils::randomFloatBetween(-0.8 - 0.5, 0.8 - 0.5);
    
    bool passed = true;
    
    //naive check
    for (int ii = 0; ii < i; ii++) {
      float dist = vec3::Distance(r1s[ii]->GetTranslate(), vec3(ux, uy, 0.0));
      printf("dist = %f\n", dist);
      if (dist < 0.175) {
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
      which = 0;
    } else {
      which = Utils::randomIntBetween(1,7);
    }
    
    RectGrating* r;
    
    switch(which) {
        
        /*
         case 7:
         r = new RectGrating(1, circleMask, color1, vec4(0.0,1.0), 5.0, 0.0, 0.0, 0.1 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 1:
         r = new RectGrating(1, circleMask, color2, vec4(0.0,1.0), 5.0, 0.0, 0.0, 0.5 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 2:
         r = new RectGrating(2, circleMask, color3, vec4(0.0,1.0), 5.0, 0.0, 45.0, 0.1 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 3:
         r = new RectGrating(3, circleMask, color4, vec4(0.0,1.0), 5.0, 0.0, 45.0, 0.5 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 4:
         r = new RectGrating(4, circleMask, color5, vec4(0.0,1.0), 10.0, 0.0, 0.0, 0.2 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 5:
         r = new RectGrating(4, circleMask, color6, vec4(0.0,1.0), 10.0, 0.0, 0.0, 1.0);
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 6:
         r = new RectGrating(4, circleMask, color7, vec4(0.0,1.0), 10.0, 0.0, 45.0, 0.2 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 0:
         r = new RectGrating(0, circleMask, color8, vec4(0.0,1.0), 10.0, 0.0, 45.0, 1.0 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         */
        
        /*
         //2x2x2 = 8 different ones - black and white
         case 2:
         r = new RectGrating(2, circleMask, colorDG, colorLG, 5.0, 0.0, 0.0, 0.1 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 1:
         r = new RectGrating(1, circleMask, colorDG, colorLG, 5.0, 0.0, 0.0, 0.5 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 0:
         r = new RectGrating(0, circleMask, colorDG, colorLG, 5.0, 0.0, 45.0, 0.1 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 3:
         r = new RectGrating(3, circleMask, colorDG, colorLG, 5.0, 0.0, 135.0, 0.5 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 4:
         r = new RectGrating(4, circleMask, colorDG, colorLG, 10.0, 0.0, 0.0, 0.2 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 5:
         r = new RectGrating(4, circleMask, colorDG, colorLG, 10.0, 0.0, 0.0, 1.0);
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 6:
         r = new RectGrating(4, circleMask, colorDG, colorLG, 10.0, 0.0, 45.0, 0.2 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 7:
         r = new RectGrating(7, circleMask, colorDG, colorLG, 10.0, 0.0, 135.0, 1.0 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         */
        
        
        //2x2x2 = 8 different ones + color
      case 2:
        r = new RectGrating(2, circleMask, color1, vec4(0.0,1.0), 5.0, 0.0, 0.0, 0.1 );
        r->SetTranslate(vec3(ux, uy, 0.0));
        r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
        r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
        break;
      case 1:
        r = new RectGrating(1, circleMask, color2, vec4(0.0,1.0), 5.0, 0.0, 0.0, 0.5 );
        r->SetTranslate(vec3(ux, uy, 0.0));
        r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
        r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
        break;
      case 0:
        r = new RectGrating(0, circleMask, color3, vec4(0.0,1.0), 5.0, 0.0, 45.0, 0.1 );
        r->SetTranslate(vec3(ux, uy, 0.0));
        r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
        r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
        break;
      case 3:
        r = new RectGrating(3, circleMask, color4, vec4(0.0,1.0), 5.0, 0.0, 45.0, 0.5 );
        r->SetTranslate(vec3(ux, uy, 0.0));
        r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
        r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
        break;
      case 4:
        r = new RectGrating(4, circleMask, color5, vec4(0.0,1.0), 10.0, 0.0, 0.0, 0.2 );
        r->SetTranslate(vec3(ux, uy, 0.0));
        r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
        r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
        break;
      case 5:
        r = new RectGrating(4, circleMask, color6, vec4(0.0,1.0), 10.0, 0.0, 0.0, 1.0);
        r->SetTranslate(vec3(ux, uy, 0.0));
        r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
        r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
        break;
      case 6:
        r = new RectGrating(4, circleMask, color7, vec4(0.0,1.0), 10.0, 0.0, 45.0, 0.2 );
        r->SetTranslate(vec3(ux, uy, 0.0));
        r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
        r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
        break;
      case 7:
        r = new RectGrating(7, circleMask, color8, vec4(0.0,1.0), 10.0, 0.0, 45.0, 1.0 );
        r->SetTranslate(vec3(ux, uy, 0.0));
        r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
        r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
        break;
        
        
        /* //only speed changes
         case 0:
         r = new RectGrating(0, circleMask, color0, vec4(0.0,1.0), 5.0, 0.0, 45.0, 0.05 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 1:
         r = new RectGrating(1, circleMask, color0, vec4(0.0,1.0), 5.0, 0.0, 45.0, 0.25 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 2:
         r = new RectGrating(2, circleMask, color0, vec4(0.0,1.0), 5.0, 0.0, 45.0, 0.6 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         
         */
        /*
         //angle by 0,45,90, speed is perceptually similar, freq = 5, 7.5, 9.0 
         case 0:
         r = new RectGrating(0, circleMask, color0, vec4(0.0,1.0), 5.0, 0.0, 0.0, 0.3 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 1:
         r = new RectGrating(1, circleMask, color0, vec4(0.0,1.0), 5.0, 0.0, 45.0, 0.3 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 2:
         r = new RectGrating(2, circleMask, color0, vec4(0.0,1.0), 5.0, 0.0, 90.0, 0.3 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 3:
         r = new RectGrating(3, circleMask, color0, vec4(0.0,1.0), 7.5, 0.0, 0.0, 0.45 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 4:
         r = new RectGrating(4, circleMask, color0, vec4(0.0,1.0), 7.5, 0.0, 45.0, 0.45 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 5:
         r = new RectGrating(4, circleMask, color0, vec4(0.0,1.0), 7.5, 0.0, 90.0, 0.45);
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 6:
         r = new RectGrating(4, circleMask, color0, vec4(0.0,1.0), 15.0, 0.0, 0.0, 0.9 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 7:
         r = new RectGrating(4, circleMask, color0, vec4(0.0,1.0), 15.0, 0.0, 45.0, 0.9 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         case 8:
         r = new RectGrating(4, circleMask, color0, vec4(0.0,1.0), 15.0, 0.0, 90.0, 0.9 );
         r->SetTranslate(vec3(ux, uy, 0.0));
         r->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
         r->SetScale(vec3(0.1, 0.1 * camera->aspect, 1.0));
         break;
         */
        
    }
    
    AddGeom(r);
    r->Transform();
    r1s[i] = r;
  }
  
    
  GetPrograms().insert(std::pair<string, Program*>("GratingPatch", new Program("GratingPatch")));
  GetPrograms().insert(std::pair<string, Program*>("OutputTexture", new Program("OutputTexture")));
  
  CreateFullScreenRect();
  BindDefaultFrameBuffer();
}


 
void RendererGrating::Render() { 
 
 bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
 
 BindDefaultFrameBuffer();
 
 Program* program = GetPrograms()["GratingPatch"]; 
 
 glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
 glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 
 
 
 int i;
 set<Geom*>::iterator it;
 for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {

   RectGrating* g = (RectGrating*) *it;
   g->phase += g->phaseSpeed;
   GratingFunctions::DrawGrating(NULL, program, g);
 }
}
 
bool RendererGrating::CheckIfAnyLeftOfKind(int kind) {
  
  
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(); it!=GetGeoms().end(); it++) {
    RectGrating* g = (RectGrating*) *it;
    
    if (g->kind == 0) {
      return true;
    }
  }
  
  return false;
}

void RendererGrating::HandleTouchBegan(ivec2 mouse) {
  
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

