

#include <iostream>
#include "RendererPanoramic.hpp"
#import <Carbon/Carbon.h> //needed for key event codes
#include "TextureCamera.hpp"

//int numRects = 1;
//Rectangle** rects;

float cx = 0.5;
float cy = 0.5;
TextureCamera* tc;

RendererPanoramic::RendererPanoramic() : Renderer() {
  printf("3. in RendererTest constructor\n");
  
}

void RendererPanoramic::Initialize() {
  
  tc = new TextureCamera();
  /*
   tc->moveCamX(-10); tc->Transform();
   tc->rotateCamY(90.0); tc->Transform();
   tc->moveCamZ(10); tc->Transform();
   
   
   vec4 p1 = vec4(0,0,0,  1);
   vec4 np1 = tc->modelview * p1;
   np1.Print();
   tc->posVec.Print();
   
   exit(0);
   */
  
  
  
  //SetCamera(new Camera(vec3(0,0,-3), 60.0, (float)width/(float)height, 0.1, 100, ivec4(0,0,width,height)));
  SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  //rects = (Rectangle**) malloc (numRects*sizeof(Rectangle*));
  
  
  printf("6. in RendererTest::Initialize()\n");
  printf("w / h = %d %d\n", width, height);
  
  
  
  Rectangle* r1 = new Rectangle(); //vec3(-2.0, -1.0, 0.0), 4.0, 2.0);
  r1->SetTranslate(vec3(-.5,-.5,0));
  //  r1->SetRotateAnchor(vec3(0.5, 0.5, 0.0));
  r1->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
  r1->SetScale(vec3(2.0, 1.0, 1.0));
  AddGeom(r1);
  r1->Transform();
  
  Program* program = new Program("UnwarpPanoramicImage");
  cout << " program ID = " << program->programID << "\n";
  GetPrograms().insert(std::pair<string, Program*>("UnwarpPanoramicImage", program));
  
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  Texture* testTexture = rh->CreateTextureFromImageFile("PanoramicTest_1.jpg");
  GetTextures().insert(pair<string, Texture*>("testTexture", testTexture));
  
  Texture* noiseTexture = Texture::CreateColorNoiseTexture(50,50);
  GetTextures().insert(pair<string, Texture*>("noiseTexture", noiseTexture));
  
  Texture* fboATexture = Texture::CreateEmptyTexture(768,1024);
  GetTextures().insert(pair<string, Texture*>("fboATexture", fboATexture));
  
  //  
  FBO* fboA = new FBO(fboATexture);
  GetFbos().insert(pair<string, FBO*>("fboA", fboA));
  //  
  
  BindDefaultFrameBuffer();
  
  
  isReady = true;
  
}

//float ddd = 0.5;

vec3 xyzVec = vec3(0.0,0.0,0.0);
float scaleVal = 1.0;
float topVal = 0.0;
float botVal = 0.0;

void RendererPanoramic::Render() { 
  
  if (!isReady) {
    //Initialize();
    printf("not ready yet!\n");
    return;
  }
  
  BindDefaultFrameBuffer();
  
  
  //if (1 == 1) return;
  
  //printf("in RendererTest::Render()\n");
  
  //ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  //rh->HandlePlayback(testTexture, false);
  //BindDefaultFrameBuffer();
  
  //camera->rotateCamY(0.1);
  
  
  //rects[0]->RotateX(1.3);
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
  
  
  
  // updateGeoms(cameraMoved);
  
  
  
  
  
  
  Program* program = GetPrograms()["UnwarpPanoramicImage"]; 
  Texture* noiseTexture = GetTextures()["testTexture"];
  
  noiseTexture->SetWrapMode(GL_MIRRORED_REPEAT);
  //noiseTexture->SetWrapMode(GL_CLAMP_TO_BORDER);
  noiseTexture->SetFilterModes(GL_NEAREST, GL_NEAREST);
  
  
  //tc->Transform();
  mat4 texRotation = tc->modelview; //::Identity();
  
  
  /*
   mat4 texRotation = mat4::Identity();
   
   texRotation = mat4::Translate(texRotation, xyzVec); 
   
   texRotation = mat4::Translate(texRotation, vec3(0.5,0.5,0.5));
   texRotation = mat4::Scale(texRotation, vec3(scaleVal,scaleVal,0.0));
   texRotation = mat4::Translate(texRotation, -vec3(0.5,0.5,0.5));
   
   
   */
  //  texRotation.Print();
  //  xyzVec.x += 0.01;
  //  texRotation = mat4::Translate(texRotation, vec3(0.5,0.5,0.5)); 
  //  texRotation = mat4::RotateX(texRotation, rotVals.x); 
  //  texRotation = mat4::RotateY(texRotation, rotVals.y); 
  //  texRotation = mat4::RotateZ(texRotation, rotVals.z); 
  //  texRotation = mat4::Translate(texRotation, -vec3(0.5,0.5,0.5)); 
  
  
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
        
        
        /*
         vector<float>& vvv = g->GetTexCoords();
         for (size_t i=0; i < vvv.size(); i+=3) {
         
         vec4 pre = vec4(vvv[i], vvv[i+1], vvv[i+2], 1.0);
         printf("pre...\n");
         pre.Print();
         vec4 post = texRotation * pre;
         printf("post...\n");
         post.Print();
         vvv[i] = post.x;
         vvv[i+1] = post.y;
         vvv[i+2] = 0.0; //post.z;
         
         //vec4 pre = vec4(vvv[i] - 0.5, vvv[i+1] - 0.5, vvv[i+2], 1.0);
         //vec4 pre = vec4(vvv[i], vvv[i+1], vvv[i+2], 1.0);
         //    printf("pre...\n");
         //    pre.Print();
         //vec4 post = rot * pre;
         //    printf("post...\n");
         //    post.Print();
         //vvv[i] += 0.005;
         //vvv[i+1] += post.y + 0.5;
         //vvv[i+2] = post.z;
         
         }
         */
        
        glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, g->GetModelView().Pointer());
        glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
        glUniformMatrix4fv(program->Uniform("TextureMatrix"), 1, 0, texRotation.Pointer());
        
        glUniform1f(program->Uniform("centerX"), cx);
        glUniform1f(program->Uniform("centerY"), cy);
        
        noiseTexture->Bind(GL_TEXTURE0); {
          glUniform1i(program->Uniform("s_tex"), 0);
          
          g->PassVertices(program, GL_TRIANGLES);
          
        } noiseTexture->Unbind(GL_TEXTURE0);
      }
    } program->Unbind();
  } fboA->Unbind();
  
  
  DrawFullScreenTexture(fboA->texture);
  
  isRendering = false;
}


void RendererPanoramic::HandleTouchMoved(ivec2 prevMouse, ivec2 mouse) {
  cx = (float)mouse.x / (float)width;
  cy = (float)mouse.y / (float)height;
  
}


void RendererPanoramic::CheckScale() {
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

void RendererPanoramic::HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function) {
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

