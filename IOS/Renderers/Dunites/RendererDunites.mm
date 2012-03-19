
#include "RendererDunites.hpp"
#include "Rectangle3D.hpp"

RendererDunites::RendererDunites() {
  printf("in RendererDunites constructor\n");
}

void RendererDunites::Initialize() {
  
  rotVals = vec3(0,0,0);
  transVals = vec3(0,0,0.5);
  scaleVal = 0.8;
  
  printf("in RendererDunites::Initialize()\n"); 
  SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  // this is still not working... fix it!
  textureCamera = new TextureCamera();
  textureCamera->moveCamZ(+0.5);
  textureCamera->Transform();
  
  Rectangle3D* r1 = new Rectangle3D(); 
  r1->SetTranslate(vec3(-.5,-.5,0));
  r1->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
  r1->SetScale(vec3(2.0, 2.0, 1.0));
  AddGeom(r1);
  r1->Transform();
  
  Program* program = new Program("Dunite3D");
  cout << " program ID = " << program->programID << "\n";
  GetPrograms().insert(std::pair<string, Program*>("Dunite3D", program));
  
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  Texture* duniteTexture = rh->LoadDunitesTexture("FILE.bmp");
  GetTextures().insert(pair<string, Texture*>("DuniteTexture", duniteTexture));
  
  BindDefaultFrameBuffer();
}

void RendererDunites::Render() { 
  
  
  Texture* duniteTexture = GetTextures()["DuniteTexture"];
  
  duniteTexture->SetWrapMode(GL_CLAMP_TO_EDGE);
  duniteTexture->SetFilterModes(GL_LINEAR, GL_LINEAR);
  
  Program* program = GetPrograms()["Dunite3D"];
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
  
  mat4 TextureMatrix = mat4::Identity();
  
  TextureMatrix = mat4::Translate(TextureMatrix, vec3(transVals)); 
  
  TextureMatrix = mat4::Translate(TextureMatrix, vec3(0.5,0.5,0.0));
  TextureMatrix = mat4::Scale(TextureMatrix, vec3(scaleVal,scaleVal,scaleVal));
  TextureMatrix = mat4::Translate(TextureMatrix, -vec3(0.5,0.5,0.0));
  
  TextureMatrix = mat4::Translate(TextureMatrix, vec3(0.5,0.5,0.5)); 
  
  if (ResourceHandler::GetResourceHandler()->IsUsingGyro()) {
    TextureMatrix *= gyroscopeMatrix;
  } else {
    TextureMatrix = mat4::RotateX(TextureMatrix, rotVals.x); 
    TextureMatrix = mat4::RotateY(TextureMatrix, rotVals.y); 
    TextureMatrix = mat4::RotateZ(TextureMatrix, rotVals.z); 
  }
  
  TextureMatrix = mat4::Translate(TextureMatrix, -vec3(0.5,0.5,0.5)); 
  
  //rotVals = vec3(0,0,45);
  // rotVals.z+=0.5;
  // rotVals.y+=0.5;
  //    rotVals.x+=0.2;
  //transVals=vec3(-0.5, 0, 0);
  // transVals.x -= 0.01;
  
  //TextureMatrix = gyroscopeMatrix;
  
  
  vec4 zzz = vec4(0.0, 0.0, 0.0, 1.0);
  vec4 ooz = vec4(1.0, 1.0, 0.0, 1.0);
  
  vec4 tz = TextureMatrix * zzz;
  vec4 to = TextureMatrix * ooz;
  
  //  printf("\ntz...");
  //  tz.Print();
  //  printf("\nto...");
  //  to.Print(); 
  
  //  textureCamera->rotateCamY(-1);
  //  //textureCamera->moveCamZ(+0.001);
  //  textureCamera->Transform();
  //  textureCamera->GetModelView().Print();
  
  program->Bind();
  
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(); it!=GetGeoms().end(); it++) {
    Geom* g = (Geom*) *it;
    glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, g->GetModelView().Pointer());
    glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
    //glUniformMatrix4fv(program->Uniform("TextureMatrix"), 1, 0, textureCamera->GetModelView().Pointer());
    glUniformMatrix4fv(program->Uniform("TextureMatrix"), 1, 0, TextureMatrix.Pointer());
    
    
    glUniform1f(program->Uniform("cols"), 10.0);
    glUniform1f(program->Uniform("rows"), 6.0);
    glUniform1f(program->Uniform("slices"), 60.0);
    
    duniteTexture->Bind(GL_TEXTURE0); {
      glUniform1i(program->Uniform("DuniteTexture"), 0);
      g->PassVertices(program, GL_TRIANGLES);
    } duniteTexture->Unbind(GL_TEXTURE0);
  }
  
  program->Unbind();
}


void RendererDunites::HandlePinch(float scale) {
  
  if (scale < 1.0)
  {  transVals.z -= 0.01;
  } else {
    transVals.z += 0.01;
  }
}

void RendererDunites::HandleTouchMoved(ivec2 prevMouse, ivec2 mouse) {
  
  if (ResourceHandler::GetResourceHandler()->IsUsingGyro()) {
    transVals.y+=(mouse.y - prevMouse.y) * .001;
    transVals.x+=(mouse.x - prevMouse.x) * .001;
  } else {
    rotVals.x+=(mouse.y - prevMouse.y) * .2;
    rotVals.y+=(prevMouse.x - mouse.x) * .2;
  }
  
  //  tc->moveCamX((prevMouse.x - mouse.x) * .002);
  //  
  //  tc->moveCamY((mouse.y - prevMouse.y) * .002);
  //  tc->Transform();
  //CheckScale();
}


void RendererDunites::HandleLongPress(ivec2 mouse) {
  //printf("RendererDunites is handling LongPress gesture\n");  
  
  if (ResourceHandler::GetResourceHandler()->IsUsingGyro()) {
    ResourceHandler::GetResourceHandler()->ResetGyroscope();
  } else {
    rotVals = vec3(0,0,0);
  }
  
  transVals = vec3(0,0,0.5);
  scaleVal = 0.8;
  
}



