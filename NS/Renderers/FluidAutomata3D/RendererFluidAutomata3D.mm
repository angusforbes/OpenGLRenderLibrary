

#include "RendererFluidAutomata3D.hpp"
#include "Rectangle3D.hpp" 
#include "Cone.hpp" 
#include "Utils.hpp" 
#import <Carbon/Carbon.h> //needed for key event codes
#include "TextureCamera.hpp"

TextureCamera* textureCamera2;

RendererFluidAutomata3D::RendererFluidAutomata3D() : Renderer() {
  printf("in RendererFluidAutomata3D constructor\n");
}

void RendererFluidAutomata3D::Initialize() {
  
  SetCamera(new Camera(vec3(0.0, 0.0, -4.0), 60.0, (float)width/(float)height, 0.1, 100, ivec4(0,0,width,height)));
  //SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  Rectangle* r2 = new Rectangle(); 
  r2->SetVertexAttributes(false, false, false);
  r2->SetTranslate(vec3(-0.5,-0.5,-0.0));
  r2->SetRotateAnchor(vec3(0.5,0.5,-0.0));
 // AddGeom(r2);
  
  Rectangle* r3 = new Rectangle(); 
  r3->SetVertexAttributes(false, false, false);
  r3->SetTranslate(vec3(-0.5,-0.5,-5.0));
  r3->SetRotateAnchor(vec3(0.5,0.5,-0.0));
 // AddGeom(r3);
  
  
  float coneStart = -10.0;
  float coneWidth = 12.0;
  int coneCols = 50;
  float coneInc = coneWidth / (coneCols - 1);
  printf("coneInc = %f\n",coneInc);
  //exit(0);
  for (int x = 0; x < coneCols; x++) {
   
    float ux = Utils::randomFloatBetween(-1.0,1.0);
    float uy = Utils::randomFloatBetween(-1.0,1.0);
    float uz = Utils::randomFloatBetween(-4.0,2.0);
    
    
    
 // for (int x = 0; x < 1; x++) {
      Cone* c1 = new Cone();
  c1->SetVertexAttributes(false, false, false);
    printf("cone... %f\n", (coneStart + (x * coneInc)));
  //c1->SetTranslate(vec3(-1.0 + (x * 0.2),-0.0,coneStart + (x * coneInc)));
      c1->SetTranslate(vec3(ux,uy,uz));
    
    //  c1->SetTranslate(vec3(-0.0,-0.0,-5.0));
    c1->SetScaleAnchor(vec3(0.0,0.0,0.0));
  c1->SetScale(0.2,0.4,1.0);
  AddGeom(c1);
  }
  //exit(0);
  Program* program = new Program("BasicShader");
  cout << " program ID = " << program->programID << "\n";
  GetPrograms().insert(std::pair<string, Program*>("BasicShader", program));
  
  
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  
   BindDefaultFrameBuffer();
  
  isReady = true;
}


void RendererFluidAutomata3D::Render() { 
  
  if (!isReady) {
    printf("not ready yet!\n");
    return;
  }
  
  BindDefaultFrameBuffer();
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    
    camera->Transform();
    cameraMoved = true;
  }
  
   
  updateGeoms(cameraMoved);
  
  //Program* program = GetPrograms()["Single3DTexture"]; 
  Program* program = GetPrograms()["BasicShader"]; 
  //Texture* threeTexture = GetTextures()["threeTexture"];
  
  
  //FBO* fboA = GetFbos()["fboA"];
  //fboA->Bind(); {
  
  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 // glEnable(GL_TEXTURE_3D);
 glEnable(GL_BLEND);
  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
   
  program->Bind(); {
    
    int i;
    set<Geom*>::iterator it;
    for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
      Geom* g = (Geom*) *it;
      g->RotateX(1 * i);
      g->GetModelView().Print();
      camera->modelview.Print();
      
      camera->projection.Print();
      glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, g->GetModelView().Pointer());
      glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
      
      g->PassVertices(program, GL_TRIANGLES);
    }
  } program->Unbind();
  //} fboA->Unbind();
  
  
  //DrawFullScreenTexture(fboA->texture);
 // glEnable(GL_TEXTURE_2D);
  //glFlush();
  isRendering = false;
}

void RendererFluidAutomata3D::MakeTextureCoords() {
  vec3 pv = textureCamera2->posVec;
   vec3 vv = textureCamera2->viewVec;
   vec3 uv = textureCamera2->upVec;
  pv.Print();
  
  vec3 ur = vec3(pv.x + vv.x, pv.y + uv.y, pv.z);
  vec3 ll = vec3(pv.x - vv.x, pv.y - uv.y, pv.z);
  ur.Print();
  ll.Print();
}

void RendererFluidAutomata3D::HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function) {
  if (command == true) {
    switch(key) {
      case kVK_UpArrow:
       // transVals.z -= 0.01;
        textureCamera2->moveCamZ(-0.01);
        textureCamera2->Transform();
       // printf("left");
        break;
      case kVK_DownArrow:
        textureCamera2->moveCamZ(+0.01);
        textureCamera2->Transform();
        
        
      //  transVals.z += 0.01;
      //  printf("right");
        break;
      case kVK_LeftArrow:
        //rotVals.z -= 1;
      //  textureCamera2->moveCam(vec3(0.5,0.5,0.5));
      //  textureCamera2->Transform();
//        
        textureCamera2->rotateCamZ(-1.0);
        textureCamera2->Transform();
       // textureCamera2->moveCam(-vec3(0.5,0.5,0.5));
       // textureCamera2->Transform();
        
        // printf("left");
        break;
      case kVK_RightArrow:
          
        textureCamera2->rotateCamZ(+1.0);
        textureCamera2->Transform();
        
        MakeTextureCoords();
        // rotVals.z += 1;
       // printf("right");
        break;
    }
  } else if (shift == true) {
    switch(key) {
      case kVK_LeftArrow:
       // textureCamera2->moveCam(vec3(0.5,0.5,0.5));
        
        textureCamera2->rotateCamY(-1.0);
        textureCamera2->Transform();
       // textureCamera2->moveCam(-vec3(0.5,0.5,0.5));
        //rotVals.y -= 1;
       // printf("left");
        break;
      case kVK_RightArrow:
       // textureCamera2->moveCam(vec3(0.5,0.5,0.5));
        
        textureCamera2->rotateCamY(+1.0);
        textureCamera2->Transform();
       // textureCamera2->moveCam(-vec3(0.5,0.5,0.5));
        //rotVals.y += 1;
      //  printf("right");
        break;
      case kVK_UpArrow:
        //textureCamera2->moveCam(vec3(0.5,0.5,0.5));
        
        textureCamera2->rotateCamX(+1.0);
        textureCamera2->Transform();
        //textureCamera2->moveCam(-vec3(0.5,0.5,0.5));
        //rotVals.x += 1;
      //  printf("up");
        break;
      case kVK_DownArrow:
        //textureCamera2->moveCam(vec3(0.5,0.5,0.5));
        
        textureCamera2->rotateCamX(-1.0);
        textureCamera2->Transform();
        //textureCamera2->moveCam(-vec3(0.5,0.5,0.5));
        //rotVals.x -= 1;
        
       // printf("down");
        break;
    }
  } else {
    
    switch(key) {
      case kVK_LeftArrow:
        textureCamera2->moveCamX(+0.01);
        textureCamera2->Transform();
        //transVals.x -= 0.01;
       // printf("left");
        break;
      case kVK_RightArrow:
        textureCamera2->moveCamX(-0.01);
        textureCamera2->Transform();
        //transVals.x += 0.01;
       // printf("right");
        break;
      case kVK_UpArrow:
        textureCamera2->moveCamY(+0.01);
         textureCamera2->Transform();
       // printf("up");
        break;
      case kVK_DownArrow:
         textureCamera2->moveCamY(-0.01);
         textureCamera2->Transform();
       // printf("down");
        break;
    }
    
  }
  
  
      
      
}

