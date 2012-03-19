

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
  
  cx = 0.5;
  cy = 0.5;
  topVal = 0.0;
  botVal = 0.0;

   
  
  //SetCamera(new Camera(vec3(0,0,-3), 60.0, (float)width/(float)height, 0.1, 100, ivec4(0,0,width,height)));
  SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  //rects = (Rectangle**) malloc (numRects*sizeof(Rectangle*));
  
  
  printf("6. in RendererTest::Initialize()\n");
  printf("w / h = %d %d\n", width, height);
  
  
  
  Rectangle* r1 = new Rectangle(); //vec3(-2.0, -1.0, 0.0), 4.0, 2.0);
  r1->SetTranslate(vec3(-.5,-.5,0));
  //  r1->SetRotateAnchor(vec3(0.5, 0.5, 0.0));
  r1->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
  r1->SetScale(vec3(2.0, 2.0*((float)width/(float)height), 1.0));
  AddGeom(r1);
  r1->Transform();
  
  
  Program* program = new Program("GratingPatch");
  //Program* program = new Program("SingleTexture");
  cout << " program ID = " << program->programID << "\n";
  GetPrograms().insert(std::pair<string, Program*>("GratingPatch", program));
  //GetPrograms().insert(std::pair<string, Program*>("SingleTexture", program));
  

  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  //rh->PlayAudioResource("precursor.mp3");
  //rh->PlayAudioResource("doorcreak.mp3");
  

  Texture* videoTexture = rh->CreateVideoTexture(PANORAMIC_MOVIE, true, true, true);
GetTextures().insert(pair<string, Texture*>("VideoTexture", videoTexture));
//  printf("1\n");

//  Texture* testTexture = rh->CreateTextureFromImageFile("PanoramicTest_1.jpg");
//Texture* testTexture = rh->CreateTextureFromImageFile("fa_1024_5.png");
//  GetTextures().insert(pair<string, Texture*>("testTexture", testTexture));
//  printf("2\n");  
  Texture* noiseTexture = Texture::CreateColorNoiseTexture(64,64);
  GetTextures().insert(pair<string, Texture*>("noiseTexture", noiseTexture));
  
  Texture* fboATexture = Texture::CreateEmptyTexture(768,1024);
  GetTextures().insert(pair<string, Texture*>("fboATexture", fboATexture));
  printf("A\n");
     printf("3\n");
  FBO* fboA = new FBO(fboATexture);
  GetFbos().insert(pair<string, FBO*>("fboA", fboA));
    printf("4\n");
  
  CreateFullScreenRect();
  
  BindDefaultFrameBuffer();

}

float phase = 0.0;
float theta = 0.0;
void RendererGrating::Render() { 
  
  //if (1 == 1) {return;}
  
 //BindDefaultFrameBuffer();
    
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
  
  // updateGeoms(cameraMoved);
  
  Program* program = GetPrograms()["GratingPatch"]; 
  //printf("program id = %d\n", program->programID);
  
  Texture* noiseTexture = GetTextures()["VideoTexture"];
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  //rh->NextVideoFrame();
  //rh->HandlePlayback(noiseTexture, true);
  
  //Texture* noiseTexture = GetTextures()["testTexture"];
  //Texture* noiseTexture = GetTextures()["noiseTexture"];
  
  //noiseTexture->SetWrapMode(GL_MIRRORED_REPEAT);
  //noiseTexture->SetWrapMode(GL_REPEAT);
  noiseTexture->SetWrapMode(GL_CLAMP_TO_EDGE);
  noiseTexture->SetFilterModes(GL_NEAREST, GL_NEAREST);
  
   
 FBO* fboA = GetFbos()["fboA"];
  fboA->Bind(); {
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_DEPTH_TEST);
    
    program->Bind(); {
      int i;
      set<Geom*>::iterator it;
      for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
        Geom* g = (Geom*) *it;
        
        glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, g->GetModelView().Pointer());
        glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
        
        glUniform4f(program->Uniform("Offset"), 0.5, 0.5, 0.5, 0.0);
        glUniform1f(program->Uniform("PhaseVal"), phase);
        glUniform1f(program->Uniform("ThetaVal"), theta);
        
        phase -= 0.0; //fmodf(phase+0.1,1.0);
        theta += 0.1;
        noiseTexture->Bind(GL_TEXTURE0); {
          //glUniform1i(program->Uniform("s_tex"), 0);
          
          g->PassVertices(program, GL_TRIANGLES);
          
        } noiseTexture->Unbind(GL_TEXTURE0);
      }
    } program->Unbind();
  } fboA->Unbind();
  
  
  DrawFullScreenTexture(fboA->texture);
 
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
