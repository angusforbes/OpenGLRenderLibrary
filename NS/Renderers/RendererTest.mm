

#include <iostream>
#include "RendererTest.hpp"

int numRects = 1;
Rectangle** rects;

RendererTest::RendererTest() : Renderer() {
  printf("3. in RendererTest constructor\n");
  
}

void RendererTest::Initialize() {
  
  //SetCamera(new Camera(vec3(0,0,-5), 60.0, (float)width/(float)height, 0.1, 100, ivec4(0,0,width,height)));
  
  rects = (Rectangle**) malloc (numRects*sizeof(Rectangle*));
  
  
  printf("6. in RendererTest::Initialize()\n");
  printf("w / h = %d %d\n", width, height);
  
  SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  
  rects[0] = new Rectangle(); //vec3(1.0, 1.0, 0.0), 2.0, 2.0);
  rects[0]->SetTranslate(vec3(-1,-1,0));
  rects[0]->SetRotateAnchor(vec3(0.5, 0.5, 0.0));
  rects[0]->SetScaleAnchor(vec3(0.0, 0.0, 0.0));
  rects[0]->SetScale(vec3(2.0, 2.0, 1.0));
  
//  rects[1] = new Rectangle(vec3(-0.5, -0.5, 0.0), 1.0, 1.0);
//  rects[1]->SetRotateAnchor(vec3(0.5, 0.5, 0.0));
//  rects[1]->SetScaleAnchor(vec3(0, 0, 0.0));
//  
//  rects[2] = new Rectangle(vec3(-0.5, -0.5, -2), 1.0, 1.0);
//  rects[2]->SetRotateAnchor(vec3(0.5, 0.5, 0.0));
  
  //  rects[1] = new Rectangle(vec3(1.0, 1.0, -1), 1.0, 1.0);
  //  
  //  rects[2] = new Rectangle(vec3(-1.0, -1.0, -2.0), 4.0, 4.0);
  
  //  SetCamera(new Camera(ivec4(0, 0, width, height)));
  //  rect = new Rectangle(vec3(-1.0, -1.0, 0.0), 2.0, 2.0);
  
  
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  Texture* testTexture = rh->CreateTextureFromImageFile("fa1_1024x768.png");
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

float ddd = 0.5;

void RendererTest::Render() { 
  
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
  
  mat4 t1 = mat4::Translate(vec3(0.5,0.5,0.0)); 
  
  mat4 rot = mat4::RotateZ(t1, ddd); 
  mat4 t2 = mat4::Translate(rot, -vec3(0.5,0.5,0.0)); 
  
  //rot.Print();
  //ddd += 0.5f;
  
  
  vector<float>& vvv = rects[0]->GetTexCoords();
  for (size_t i=0; i < vvv.size(); i+=3) {
  
    vec4 pre = vec4(vvv[i] - 0.5, vvv[i+1] - 0.5, vvv[i+2], 1.0);
    //vec4 pre = vec4(vvv[i], vvv[i+1], vvv[i+2], 1.0);
//    printf("pre...\n");
//    pre.Print();
    vec4 post = rot * pre;
//    printf("post...\n");
//    post.Print();
    vvv[i] = post.x + 0.5;
    vvv[i+1] = post.y + 0.5;
    vvv[i+2] = post.z;
    
  }
  
  
 // exit(0);
  //rects[0]->RotateZ(1.0);
  //  rects[1]->RotateX(-5.0);
  //  rects[2]->RotateX(-3.0);
  
  for (int i = 0; i < numRects; i++) {
    //rects[i]->RotateX(5.0);
    
    if (rects[i]->IsTransformed() || cameraMoved) {
      rects[i]->Transform();
    }
  }
  
  Program* program = GetPrograms()["SingleTexture"]; 
  Texture* noiseTexture = GetTextures()["testTexture"];
  
  
  FBO* fboA = GetFbos()["fboA"];
  
  //fboA->Bind(); {
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   // glEnable(GL_DEPTH_TEST);
    
  
  camera->projection.Print();
  
    program->Bind(); {
      
      for (int i = 0; i < numRects; i++) {
        
        glUniform1i(program->Uniform("band"), i);
        glUniform1i(program->Uniform("numBands"), 3);
        
        glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, rects[i]->GetModelView().Pointer());
        glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
        
        noiseTexture->Bind(GL_TEXTURE0); {
          glUniform1i(program->Uniform("s_tex"), 0);
          
          rects[i]->PassVertices(program, GL_TRIANGLES);
          
        } noiseTexture->Unbind(GL_TEXTURE0);
      }
    } program->Unbind();
 // } fboA->Unbind();
  
  
  //DrawFullScreenTexture(fboA->texture);
  
  isRendering = false;
}
