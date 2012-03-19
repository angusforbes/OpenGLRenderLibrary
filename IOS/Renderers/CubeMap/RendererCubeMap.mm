

#include <iostream>
#include "RendererCubeMap.hpp"
#include "IOSGLView.h"
#include "Utils.hpp"

GLfloat* cubeVertices;

GLuint depthTextureTest;

//RendererCubeMap::RendererCubeMap(void* _view) : Renderer(_view){
//  printf("RendererCubeMap::RendererCubeMap(void* _view)\n");
//}
RendererCubeMap::RendererCubeMap() {
  printf("RendererCubeMap::RendererCubeMap(void* _view)\n");
}

/*
RendererCubeMap::RendererCubeMap() {
  printf("RendererCubeMap::RendererCubeMap()\n");
 // ResourceHandler* rh = ResourceHandler::GetResourceHandler();
}
*/


void RendererCubeMap::AddUI() {
  printf("renderer cube map is adding a UI\n"); 
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setTitle:@"Show View" forState:UIControlStateNormal];
  button.frame = CGRectMake(80.0, 210.0, 160.0, 80.0);
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  //[(IOSGLView*)rh->GetView() addSubview:button];
  [(UIView*)rh->GetView() addSubview:button];
}


void RendererCubeMap::Initialize() {
  
  SetCamera(new Camera(vec3(0,0,0), 60.0, (float)width/(float)height, 0.1, 100, ivec4(0,0,width, height)));
  //camera->rotateCamY(45.0);
  printf("in RendererCubeMap::Initialize()\n"); 
  
  myCube = new Cube(vec3(0,0,0), 3.0); //skybox
    
  Program* program = new Program("BasicShader");
  cout << " program ID = " << program->programID << "\n";
  GetPrograms().insert(std::pair<string, Program*>("BasicShader", program));
  
  
  //load in cubemap
  Texture* cubemapTexture = Texture::CreateCubeMapFromImageFile("desert.png");
  //Texture* cubemapTexture = Texture::CreateCubeMapFromImageFile("fa_2048.png");
  //Texture* cubemapTexture = Texture::CreateCubeMapFromImageFile("fa_1024.png");
  //Texture* cubemapTexture = Texture::CreateCubeMapTest();
  GetTextures().insert(pair<string, Texture*>("cm", cubemapTexture));
  
  Program* program4 = new Program("Skybox");
  cout << " program ID = " << program4->programID << "\n";
  GetPrograms().insert(pair<string, Program*>("Skybox", program4));
  
  //BindDefaultFrameBuffer();
  
//  glViewport(camera->viewport.x, camera->viewport.y, camera->viewport.z, camera->viewport.w);
//  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);

 
 
  
  
 
//  glGenTextures(1, &depthTextureTest);
//  glBindTexture(GL_TEXTURE_2D, depthTextureTest);
//  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,  width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, NULL);
//  glFramebufferTexture2D(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_TEXTURE_2D, depthTextureTest, 0);
  
  /*
  int tW = 11;
  int tH = 11;
  GLubyte* texturedata2 = (GLubyte*) malloc (tW*tH*4*sizeof(GLubyte));
  
  
  for (int x = 0; x < tW*tH*4; x+=4) {
    texturedata2[x] = 100;
    texturedata2[x+1] = 0;
    texturedata2[x+2] = 0;
    texturedata2[x+3] = 255;
  }
  glTexSubImage2D(GL_TEXTURE_2D, 0, tX, tY, tW, tH, GL_RGBA, GL_UNSIGNED_BYTE, (GLvoid*)texturedata2);
  */

}

void RendererCubeMap::Render() { 
  
   
   
  
  if (camera->IsTransformed() == true) {
    camera->Transform();
  }
  
  drawSkybox(myCube, GetTextures()["cm"]);
  
 
}

void RendererCubeMap::drawSkybox(Cube* cube, Texture* tex) {
  
  BindDefaultFrameBuffer();
  
  cube->Transform();
  
  glEnable(GL_DEPTH_TEST); 
  glDepthFunc(GL_LESS);
  
  //Need to make sure Skybox is already loaded!!!
  Program* program = GetPrograms()["Skybox"];
  glUseProgram(program->programID);
  
  tex->Bind(GL_TEXTURE0);
  glUniform1i(program->Uniform("Sampler"), 0);
  
  //glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, camera->GetModelView().Pointer());
  glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, cube->GetModelView().Pointer());
  //printf("camera mv:\n");
  //camera->GetModelView().Print();
  //printf("cube mv:\n");
  //cube->GetModelView().Print();
  //printf("\n\n");
  
  glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
  
  
  
  glEnableVertexAttribArray ( program->Attribute("Position") );
  
  int stride = 3 * sizeof(GLfloat); //vertices only (for now)
  glVertexAttribPointer( program->Attribute("Position"), 3, GL_FLOAT, GL_FALSE, stride, &cube->vertices[0] );
  
  glDrawElements( GL_TRIANGLES, cube->GetTriangleIndexCount(), GL_UNSIGNED_SHORT, &cube->triangleIndices[0] );
  
  glDisableVertexAttribArray ( program->Attribute("Position") );
  
  program->Unbind();
}



void RendererCubeMap::UpdateCubeTexture(Texture* cubemap, int face, vec2 hitTexCoords) {
  
  cubemap->Bind(GL_TEXTURE0);

  int tW = 11;
  int tH = 11;
  
  int tX = (int) (cubemap->width * hitTexCoords.x) - (tW/2);
  int tY = (int) (cubemap->height * hitTexCoords.y) - (tH/2);
  
  GLubyte* texturedata2 = (GLubyte*) malloc (tW*tH*4*sizeof(GLubyte));
  for (int x = 0; x < tW*tH*4; x+=4) {
    texturedata2[x] = 50 * face;
    texturedata2[x+1] = 0;
    texturedata2[x+2] = 0;
    texturedata2[x+3] = 255;
  }

  switch(face) {
    case 0:
      glTexSubImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_X, 0, tX, tY, tW, tH, GL_RGBA, GL_UNSIGNED_BYTE, (GLvoid*)texturedata2);
      break;
    case 1:
      glTexSubImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_X, 0, tX, tY, tW, tH, GL_RGBA, GL_UNSIGNED_BYTE, (GLvoid*)texturedata2);
      break;
    case 2:
      glTexSubImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, tX, tY, tW, tH, GL_RGBA, GL_UNSIGNED_BYTE, (GLvoid*)texturedata2);
      break;
    case 3:
      glTexSubImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Y, 0, tX, tY, tW, tH, GL_RGBA, GL_UNSIGNED_BYTE, (GLvoid*)texturedata2);
      break;
    case 4:
      glTexSubImage2D(GL_TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, tX, tY, tW, tH, GL_RGBA, GL_UNSIGNED_BYTE, (GLvoid*)texturedata2);
      break;
    case 5:
      glTexSubImage2D(GL_TEXTURE_CUBE_MAP_POSITIVE_Z, 0, tX, tY, tW, tH, GL_RGBA, GL_UNSIGNED_BYTE, (GLvoid*)texturedata2);
      break;
  }
  
  cubemap->Unbind(GL_TEXTURE0);
 // glBindRenderbuffer(GL_RENDERBUFFER, m_colorRenderbuffer); 
  
}

void RendererCubeMap::HandleTouchMoved(ivec2 prevMouse, ivec2 mouse) {  
  IntersectCube(mouse);
  
}

void RendererCubeMap::HandleTouchBegan(ivec2 mouse) {
  camera->moveCamZ(+.1);
  //camera->rotateCamY(40);
  //camera->moveCamX(-.1);
  
  IntersectCube(mouse); 
}

void RendererCubeMap::HandleTouchEnded(ivec2 mouse) {
  // camera->moveCamZ(-.1);
  //camera->Reset();
  //IntersectCube(mouse); 
}

void RendererCubeMap::HandleLongPress(ivec2 mouse) {
  printf("renderer is handling LongPress gesture\n");  
  //ResourceHandler::GetResourceHandler()->ResetGyroscope();
 
  
  IOSGLView* v = (IOSGLView*) ResourceHandler::GetResourceHandler()->GetView();
  //GLView* v = (GLView*) view; 
  v.referenceAttitude = [v.motionManager.deviceMotion.attitude retain];
  
  camera->Reset();
  
   }

void RendererCubeMap::HandlePinch(float scale) {
  printf("renderer is handling Pinch gesture\n");  
}

float rotAmt2 = 0.0; //testing

void RendererCubeMap::IntersectCube(ivec2 mouse) {
  
  ray3 pr = Utils::GetPickingRay(mouse.x, mouse.y);
    
  vec3 hitPt = vec3();
  vec2 hitTexCoords = vec2();
  int face;
  
  if ( myCube->Intersect(pr, face, hitPt, hitTexCoords) ) {
    UpdateCubeTexture(GetTextures()["cm"], face, hitTexCoords);
  }
  
  //this is just a test... really move with other controls, or with gyroscope
 // mat4 tmpRotMat = mat4::Identity();
 // tmpRotMat = mat4::RotateX(tmpRotMat, rotAmt2);
//  tmpRotMat = mat4::RotateY(tmpRotMat, rotAmt2 * .5);
//  tmpRotMat = mat4::RotateZ(tmpRotMat, rotAmt2 * 1.5);
 // rotAmt2 += 5.0;
  //printf("rotAmt2 = %f\n", rotAmt2);
  
 // SetCameraRotation(tmpRotMat);
}


