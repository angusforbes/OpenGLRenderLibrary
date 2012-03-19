

#include "RendererTexture3D.hpp"
#include "Rectangle3D.hpp" 
#import <Carbon/Carbon.h> //needed for key event codes
#include "TextureCamera.hpp"

TextureCamera* textureCamera;

RendererTexture3D::RendererTexture3D() : Renderer() {
  printf("in RendererTexture3D constructor\n");
}


vec3 rotVals = vec3(0,0,0);
vec3 transVals = vec3(1,1,1);

void RendererTexture3D::Initialize() {
  
  //SetCamera(new Camera(vec3(0.0, 0.0, -5.0), 60.0, (float)width/(float)height, 0.1, 100, ivec4(0,0,width,height)));
  SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  textureCamera = new TextureCamera();
  
  /*
  
  //TEST
  
  //rotVals = vec3(0,0,45);
  //  rotVals.z+=0.5;
  //  rotVals.y+=0.1;
  //  rotVals.x+=0.2;
  //1transVals=vec3(-0.5, 0, 0);

  mat4 texRotation = mat4::Identity();
  
  texRotation = mat4::Translate(texRotation, vec3(transVals)); 
 
  
  texRotation = mat4::Translate(texRotation, vec3(0.5,0.5,0.5));
  //texRotation = mat4::Scale(texRotation, vec3(0.5,0.5,0.5));
  texRotation = mat4::Translate(texRotation, -vec3(0.5,0.5,0.5));
  
 // texRotation = mat4::Translate(texRotation, vec3(0.5,0.5,0.5)); 
//  texRotation = mat4::RotateX(texRotation, rotVals.x); 
//  texRotation = mat4::RotateY(texRotation, rotVals.y); 
  texRotation = mat4::RotateZ(texRotation, rotVals.z); 
 // texRotation = mat4::Translate(texRotation, -vec3(0.5,0.5,0.5)); 
  
  
  printf("A\n");
  texRotation.Print();
  
  textureCamera->moveCam(transVals);
  textureCamera->Transform();
//  textureCamera->rotateCamZ(rotVals.z);
//  textureCamera->Transform();
  printf("B\n");
  textureCamera->modelview.Print();
  */
  //exit(0);
  
  //END TEST
  
  
  
  Rectangle3D* r1 = new Rectangle3D();
  r1->SetTranslate(vec3(-1,-1,0));
  r1->SetRotateAnchor(vec3(0.5, 0.5, 0.0));
  r1->SetScaleAnchor(vec3(0.0, 0.0, 0.0));
  r1->SetScale(vec3(2.0, 2.0, 1.0));
  
  //Rectangle3D* r2 = new Rectangle3D(vec3(+1.0, 1.0, 0.0), 1.0, 2.0);
  AddGeom(r1);
  r1->Transform();
  //AddGeom(r2);
  
  //RemoveGeom(r1);
  
  printf("in RendererTexture3D::Initialize()\n");
  printf("w / h = %d %d\n", width, height);
  
  
  /*
  
  rects[0] = new Rectangle(vec3(-1.0, -1.0, 0.0), 2.0, 2.0);
  rects[0]->SetRotateAnchor(vec3(1.0, 1.0, -1.0));
  
  rects[1] = new Rectangle(vec3(-1.0, -1.0, -1), 2.0, 2.0);
  rects[1]->SetRotateAnchor(vec3(1.0, 1.0, 0.0));
  rects[1]->SetScaleAnchor(vec3(1.0, 1.0, 0.0));
  
  rects[2] = new Rectangle(vec3(-1.0, -1.0, -2), 2.0, 2.0);
  rects[2]->SetRotateAnchor(vec3(1.0, 1.0, +1.0));
  
  //  rects[1] = new Rectangle(vec3(1.0, 1.0, -1), 1.0, 1.0);
  //  
  //  rects[2] = new Rectangle(vec3(-1.0, -1.0, -2.0), 4.0, 4.0);
  
  //  SetCamera(new Camera(ivec4(0, 0, width, height)));
  //  rect = new Rectangle(vec3(-1.0, -1.0, 0.0), 2.0, 2.0);
  */
  Program* program = new Program("Single3DTexture");
  cout << " program ID = " << program->programID << "\n";
  GetPrograms().insert(std::pair<string, Program*>("Single3DTexture", program));
  
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  
  /*
  Texture* testTexture = rh->CreateTextureFromImageFile("fa1_1024x768.png");
  GetTextures().insert(pair<string, Texture*>("testTexture", testTexture));
  
  Texture* noiseTexture = Texture::CreateColorNoiseTexture(50,50);
  GetTextures().insert(pair<string, Texture*>("noiseTexture", noiseTexture));
  */
  
  //Texture* threeTexture = Texture::Create3DTextureFromImageFiles(");
  //GetTextures().insert(pair<string, Texture*>("threeTexture", threeTexture));
  
  ////REAL ONE for DUNITES DATA - UNOCMMENT WHEN YOU FIX IOS/NS MERGE
  
//  Texture* threeTexture = rh->LoadDunitesTexture("FILE.bmp");
//  GetTextures().insert(pair<string, Texture*>("threeTexture", threeTexture));
  
  ///END REAL ONE...
  
//  Texture* threeTexture = Texture::Create3DTextureTest();
//  GetTextures().insert(pair<string, Texture*>("threeTexture", threeTexture));
//  
  /*
  Texture* fboATexture = Texture::CreateEmptyTexture(768,1024);
  GetTextures().insert(pair<string, Texture*>("fboATexture", fboATexture));
  
  FBO* fboA = new FBO(fboATexture);
  GetFbos().insert(pair<string, FBO*>("fboA", fboA));
  */
  
  BindDefaultFrameBuffer();
  
  isReady = true;
}


void RendererTexture3D::Render() { 
  
  if (!isReady) {
    printf("not ready yet!\n");
    return;
  }
  
  BindDefaultFrameBuffer();
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    //camera->Transform();
    cameraMoved = true;
  }
  
  if (textureCamera->IsTransformed()) {
 //   textureCamera->Transform();
  }

  

  
  //updateGeoms(cameraMoved);
  
    
  Program* program = GetPrograms()["Single3DTexture"]; 
  Texture* threeTexture = GetTextures()["threeTexture"];
  
  
  //FBO* fboA = GetFbos()["fboA"];
  //fboA->Bind(); {
  
  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glEnable(GL_TEXTURE_3D);
 glDisable(GL_BLEND);
//  glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glDisable(GL_DEPTH_TEST);
  
  
 
  
  mat4 texRotation = mat4::Identity();
  
  texRotation = mat4::Translate(texRotation, vec3(transVals)); 
  
  texRotation = mat4::Translate(texRotation, vec3(0.5,0.5,0.5));
  //texRotation = mat4::Scale(texRotation, vec3(0.5,0.5,0.5));
  texRotation = mat4::Translate(texRotation, -vec3(0.5,0.5,0.5));
  
  texRotation = mat4::Translate(texRotation, vec3(0.5,0.5,0.5)); 
  texRotation = mat4::RotateX(texRotation, rotVals.x); 
  texRotation = mat4::RotateY(texRotation, rotVals.y); 
  texRotation = mat4::RotateZ(texRotation, rotVals.z); 
  texRotation = mat4::Translate(texRotation, -vec3(0.5,0.5,0.5)); 
  
  rotVals = vec3(0,0,45);
//  rotVals.z+=0.5;
//  rotVals.y+=0.1;
//  rotVals.x+=0.2;
  transVals=vec3(-0.5, 0, 0);

  
  
//  transVals.x+=0.001;
  //texRotation.Print();
  
//  vec4 tR2 = texRotation * vec4(.5,.5,.5,1);
//  tR2.Print();
  
  
  //threeTexture->SetWrapMode(GL_CLAMP);
  threeTexture->SetWrapMode(GL_MIRRORED_REPEAT);
  //threeTexture->SetFilterModes(GL_NEAREST, GL_NEAREST);
  
   
  program->Bind(); {
    
    //printf("tcVal = %03f %03f %03f\n", tcValX, tcValY, tcValZ);
    
    int i;
    set<Geom*>::iterator it;
   // for (int i = 0; i < GetGeoms().size(); i++) {
    for (it=GetGeoms().begin(), i = 0; it!=GetGeoms().end(); it++, i++) {
      Geom* g = (Geom*) *it;
   
      glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, g->GetModelView().Pointer());
      glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
       
      glUniformMatrix4fv(program->Uniform("texRotation"), 1, 0, textureCamera->GetModelView().Pointer());
      //glUniformMatrix4fv(program->Uniform("texRotation"), 1, 0, texRotation.Pointer());
      
      
      threeTexture->Bind(GL_TEXTURE0); {
        
        glUniform1i(program->Uniform("s_tex"), 0);
        
        g->PassVertices(program, GL_TRIANGLES);
              
      } threeTexture->Unbind(GL_TEXTURE0);
    }
  } program->Unbind();
  //} fboA->Unbind();
  
  
  //DrawFullScreenTexture(fboA->texture);
  glEnable(GL_TEXTURE_2D);
  //glFlush();
  isRendering = false;
}

void RendererTexture3D::MakeTextureCoords() {
  vec3 pv = textureCamera->posVec;
   vec3 vv = textureCamera->viewVec;
   vec3 uv = textureCamera->upVec;
  pv.Print();
  
  vec3 ur = vec3(pv.x + vv.x, pv.y + uv.y, pv.z);
  vec3 ll = vec3(pv.x - vv.x, pv.y - uv.y, pv.z);
  ur.Print();
  ll.Print();
}

void RendererTexture3D::HandleKeyDown(char key, bool shift, bool control, bool command, bool option, bool function) {
  if (command == true) {
    switch(key) {
      case kVK_UpArrow:
       // transVals.z -= 0.01;
        textureCamera->moveCamZ(-0.01);
        textureCamera->Transform();
       // printf("left");
        break;
      case kVK_DownArrow:
        textureCamera->moveCamZ(+0.01);
        textureCamera->Transform();
        
        
      //  transVals.z += 0.01;
      //  printf("right");
        break;
      case kVK_LeftArrow:
        //rotVals.z -= 1;
      //  textureCamera->moveCam(vec3(0.5,0.5,0.5));
      //  textureCamera->Transform();
//        
        textureCamera->rotateCamZ(-1.0);
        textureCamera->Transform();
       // textureCamera->moveCam(-vec3(0.5,0.5,0.5));
       // textureCamera->Transform();
        
        // printf("left");
        break;
      case kVK_RightArrow:
          
        textureCamera->rotateCamZ(+1.0);
        textureCamera->Transform();
        
        MakeTextureCoords();
        // rotVals.z += 1;
       // printf("right");
        break;
    }
  } else if (shift == true) {
    switch(key) {
      case kVK_LeftArrow:
       // textureCamera->moveCam(vec3(0.5,0.5,0.5));
        
        textureCamera->rotateCamY(-1.0);
        textureCamera->Transform();
       // textureCamera->moveCam(-vec3(0.5,0.5,0.5));
        //rotVals.y -= 1;
       // printf("left");
        break;
      case kVK_RightArrow:
       // textureCamera->moveCam(vec3(0.5,0.5,0.5));
        
        textureCamera->rotateCamY(+1.0);
        textureCamera->Transform();
       // textureCamera->moveCam(-vec3(0.5,0.5,0.5));
        //rotVals.y += 1;
      //  printf("right");
        break;
      case kVK_UpArrow:
        //textureCamera->moveCam(vec3(0.5,0.5,0.5));
        
        textureCamera->rotateCamX(+1.0);
        textureCamera->Transform();
        //textureCamera->moveCam(-vec3(0.5,0.5,0.5));
        //rotVals.x += 1;
      //  printf("up");
        break;
      case kVK_DownArrow:
        //textureCamera->moveCam(vec3(0.5,0.5,0.5));
        
        textureCamera->rotateCamX(-1.0);
        textureCamera->Transform();
        //textureCamera->moveCam(-vec3(0.5,0.5,0.5));
        //rotVals.x -= 1;
        
       // printf("down");
        break;
    }
  } else {
    
    switch(key) {
      case kVK_LeftArrow:
        textureCamera->moveCamX(+0.01);
        textureCamera->Transform();
        //transVals.x -= 0.01;
       // printf("left");
        break;
      case kVK_RightArrow:
        textureCamera->moveCamX(-0.01);
        textureCamera->Transform();
        //transVals.x += 0.01;
       // printf("right");
        break;
      case kVK_UpArrow:
        textureCamera->moveCamY(+0.01);
         textureCamera->Transform();
       // printf("up");
        break;
      case kVK_DownArrow:
         textureCamera->moveCamY(-0.01);
         textureCamera->Transform();
       // printf("down");
        break;
    }
    
  }
  
  
      
      
}

