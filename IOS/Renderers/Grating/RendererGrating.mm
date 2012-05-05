

#include <iostream>
#include "RendererGrating.hpp"
//#import <Carbon/Carbon.h> //needed for key event codes


//#define PANORAMIC_MOVIE "ctango.mov" 
#define PANORAMIC_MOVIE "AlloPano5Mbps.mov"
//#define PANORAMIC_MOVIE "AlloPano_5MB_Sound.mov"
//#define PANORAMIC_MOVIE "AlloPano_5MB_Sound_smaller.m4v"




RendererGrating::RendererGrating() { //: Renderer() {
  printf("3. in RendererGrating constructor\n");
}

void RendererGrating::Initialize() {
  
  freq1 = 10.0;
  phase1 = 0.0;
  theta1 = 90.0;
  color1 = vec4(1.0,0.0,0.0,0.5);
  backgroundColor1 = vec4(0.0,1.0,0.0,0.0);
  
  freq2 = 13.0;
  phase2 = 0.0;
  theta2 = 0.0;
  color2 = vec4(0.0,0.0,1.0,0.5);
  backgroundColor2 = vec4(1.0,0.0,0.0,0.0);
  
  cx = 0.5;
  cy = 0.5;
  topVal = 0.0;
  botVal = 0.0;

  //SetCamera(new Camera(vec3(0,0,-3), 60.0, (float)width/(float)height, 0.1, 100, ivec4(0,0,width,height)));
  //SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  //rects = (Rectangle**) malloc (numRects*sizeof(Rectangle*));
  
  
  printf("6. in RendererTest::Initialize()\n");
  printf("w / h = %d %d\n", width, height);
  

  Rectangle* r1 = new Rectangle(); //vec3(-2.0, -1.0, 0.0), 4.0, 2.0);
  r1->SetTranslate(vec3(-0.5,-0.5,0));
  //  r1->SetRotateAnchor(vec3(0.5, 0.5, 0.0));
  r1->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
  //r1->SetScale(vec3(2.0, 2.0*((float)width/(float)height), 1.0));
  //r1->SetScale(vec3(1.0, 1.0, 1.0));
  r1->SetScale(vec3(2.0, 2.0, 1.0));
  AddGeom(r1);
  r1->Transform();
  
  GetPrograms().insert(std::pair<string, Program*>("GratingPatch", new Program("GratingPatch")));
  GetPrograms().insert(std::pair<string, Program*>("BlendTextures", new Program("BlendTextures")));
  
  //CreateTexture("noiseTexture", Texture::CreateColorNoiseTexture(64,64));
  CreateFBO("fboA", Texture::CreateEmptyTexture(1024/4,1024/4));
  CreateFBO("fboB", Texture::CreateEmptyTexture(1024/4,1024/4));
  CreateFBO("fboC", Texture::CreateEmptyTexture(1024/4,1024/4));
  
  
  CreateFullScreenRect();
  
  BindDefaultFrameBuffer();

}

void RendererGrating::BlendTextures(FBO* fbo, Texture* t1, Texture* t2){
  
  Program* program = GetPrograms()["BlendTextures"]; 
  
  //fbo->Bind(); {
    
    program->Bind(); {
      int i;
      vector<Geom*>::iterator it;
      for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
        Geom* g = (Geom*) *it;
        
        glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, g->GetModelView().Pointer());
        glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
        
        t1->Bind(GL_TEXTURE0); 
        glUniform1i(program->Uniform("tex0"), 0);
        
        t2->Bind(GL_TEXTURE1); 
        glUniform1i(program->Uniform("tex1"), 1);
        
        g->PassVertices(program, GL_TRIANGLES);
        
        t1->Unbind(GL_TEXTURE0); 
        t2->Unbind(GL_TEXTURE1); 
        
      }
    } program->Unbind();
  //} fbo->Unbind();
  
}


void RendererGrating::DrawGrating(FBO* fbo, float freq, float phase, float theta, vec4 *color, vec4 *backgroundColor) {
  
  Program* program = GetPrograms()["GratingPatch"]; 
  
  fbo->Bind(); {
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_DEPTH_TEST);
    
    program->Bind(); {
      int i;
      vector<Geom*>::iterator it;
      for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
        Geom* g = (Geom*) *it;
        
        glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, g->GetModelView().Pointer());
        glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
        
        glUniform4fv(program->Uniform("ContrastColor"), 1, backgroundColor->Pointer());
        glUniform4fv(program->Uniform("BaseColor"), 1, color->Pointer());
        glUniform1f(program->Uniform("FreqVal"), freq * (M_PI*2.0));
        glUniform1f(program->Uniform("PhaseVal"), phase);
        glUniform1f(program->Uniform("ThetaVal"), radians(theta));
        
        g->PassVertices(program, GL_TRIANGLES);
      }
    } program->Unbind();
  } fbo->Unbind();
  
}

void RendererGrating::Render() { 
  
 
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
   
  theta1 += 1.0;
  theta2 -= 1.0;
  
  DrawGrating(GetFbos()["fboA"], freq1, phase1, (theta1), &color1, &backgroundColor1);
  DrawGrating(GetFbos()["fboB"], freq2, phase2, (theta2), &color2, &backgroundColor2);
  
  BindDefaultFrameBuffer();
  BlendTextures(GetFbos()["fboC"], GetFbos()["fboA"]->texture, GetFbos()["fboB"]->texture);
  
  
  //DrawFullScreenTexture(GetFbos()["fboC"]->texture);
  
}

/*
void RendererGrating::HandleTouchMoved(ivec2 prevMouse, ivec2 mouse) {
  cx = (float)mouse.x / (float)width;
  cy = (float)mouse.y / (float)height;
  
}
*/

void RendererGrating::CheckScale() {
  //this method keeps the visible y texture coords within 0.0 and 1.0 regardless of scaling
  
  
  topVal = (tc->modelview * vec4(0.0,1.0,0.0,1.0)).y;
  botVal = (tc->modelview * vec4(0.0,0.0,0.0,1.0)).y;
  
  if (topVal > 1.0) {
    tc->moveCamY(-(1.0 - topVal));
    tc->Transform();
    
  } else if (botVal < 0.0) {
    tc->moveCamY(botVal);
    tc->Transform();
  }
    
}


void RendererGrating::HandlePinch(float scale) {
  printf("in handlePinch %f\n", scale);
  if (scale < 1.0 && tc->GetScale().x > 0.04) {
    tc->Scale(-0.04); //zoomIn
    tc->Transform();
  } 
  
  if (scale > 1.0 && tc->GetScale().x <= 0.96) {
    tc->Scale(+0.04); //zoomIn
    tc->Transform();
    CheckScale();
    
  } 
  
  
}
void RendererGrating::HandleTouchMoved(ivec2 prevMouse, ivec2 mouse) {
  
    tc->moveCamX((prevMouse.x - mouse.x) * .002);
   
  tc->moveCamY((mouse.y - prevMouse.y) * .002);
  tc->Transform();
  CheckScale();
}
/*
void RendererGrating::HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function) {
  if (command == true) {
    switch(key) {
      case kVK_UpArrow:
        if (tc->GetScale().x > 0.01) {
          tc->Scale(-0.01); //zoomIn
          tc->Transform();
        } 
        
        break;
      case kVK_DownArrow:
        if (tc->GetScale().x <= 0.99) {
          tc->Scale(+0.01); //zoomOut
          tc->Transform();
          CheckScale();
        } 
        
        break;
        
    }
  } else {
    
    switch(key) {
      case kVK_RightArrow:
        
        tc->moveCamX(-0.01);
        tc->Transform();
        
        break;
      case kVK_LeftArrow:
        tc->moveCamX(+0.01);
        tc->Transform();
        break;
      case kVK_DownArrow:
        tc->moveCamY(+0.01);
        tc->Transform();
        CheckScale();
        break;
      case kVK_UpArrow:
        tc->moveCamY(-0.01);
        tc->Transform();
        CheckScale();
        //      
        //        if (botVal > .01) {
        //          xyzVec.y -= 0.01;
        //        }
        //        
        //        
        //        if (topVal < 0.0) {
        //          xyzVec.y = 0.0;
        //        }
        
        break;
    }
    
    
    
  }
  
  
  
  
}
*/
