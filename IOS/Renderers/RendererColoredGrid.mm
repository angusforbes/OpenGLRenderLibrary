

#include <iostream>
#include "RendererColoredGrid.hpp"
//#include "IOSGLView.h"
#include "Grid.hpp"

Grid* grid;

//RendererColoredGrid::RendererColoredGrid(void* _view) : Renderer(_view){
//  printf("RendererCubeMap::RendererCubeMap(void* _view)\n");
//}

RendererColoredGrid::RendererColoredGrid(void* _view) { 
  printf("RendererColoredGrid::RendererColoredGrid()\n");
}


/*
 RendererCubeMap::RendererCubeMap() {
 printf("RendererCubeMap::RendererCubeMap()\n");
 // ResourceHandler* rh = ResourceHandler::GetResourceHandler();
 }
 */

void RendererColoredGrid::Initialize() {
  
  SetCamera(new Camera(ivec4(0, 0, width, height)));
  //SetCamera(new Camera(vec3(0,0,0), 60.0, (float)width/(float)height, 0.1, 100, ivec4(0,0,width, height)));
  //camera->rotateCamY(5.0);
  printf("in RendererColoredGrid::Initialize()\n"); 
  
  grid = new Grid(vec3(-1,-1,0), 2.0, 2.0, 50, 50); 
  
  Program* program = new Program("VertexTexture");
  cout << " program ID = " << program->programID << "\n";
  GetPrograms().insert(std::pair<string, Program*>("VertexTexture", program));
  
  //Texture* img = Texture::CreateTextureFromImageFile("fa_1024_0.png");
  Texture* img = Texture::CreateTextureFromImageFile("fa1_50.png");
  GetTextures().insert(pair<string, Texture*>("img", img));
  
  glViewport(camera->viewport.x, camera->viewport.y, camera->viewport.z, camera->viewport.w);
  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
  
  isRendering = false;
  isReady = true;
  
    
}

int frameNum = 0;

void RendererColoredGrid::Render() { 
  frameNum++;
  printf("frameNum = %d\n", frameNum);
  if (!isReady) {
    printf("not ready yet!\n");
    return;
  }
  //camera->rotateCamY(0.01);
  isRendering = true;
  
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  if (camera->IsTransformed() == true) {
    camera->Transform();
  }
  
  grid->Transform();
  
  Program* program = GetPrograms()["VertexTexture"];
   program->Bind();
  
  
  Texture* tex = GetTextures()["img"];
  
  
  tex->Bind(GL_TEXTURE0);
  glUniform1i(program->Uniform("s_tex"), 0);

  glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, grid->GetModelView().Pointer());
  glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
  
  grid->modelview.Print();
  
   
  
  
  int stride = 5 * sizeof(GLfloat);
  glVertexAttribPointer ( program->Attribute("position"), 3, GL_FLOAT, 
                         GL_FALSE, stride, &grid->vertices[0] );
  glVertexAttribPointer ( program->Attribute("texCoord"), 2, GL_FLOAT,
                         GL_FALSE, stride, &grid->vertices[3] );
  
  glEnableVertexAttribArray ( program->Attribute("position") );
  glEnableVertexAttribArray ( program->Attribute("texCoord") );
  
  int indexCount = grid->GetTriangleIndexCount();
  
  glDrawElements( GL_TRIANGLES, indexCount, GL_UNSIGNED_SHORT, &grid->triangleIndices[0] );
  
  
  glDisableVertexAttribArray ( program->Attribute("position") );
  glDisableVertexAttribArray ( program->Attribute("texCoord") );

  tex->Unbind(GL_TEXTURE0);
  program->Unbind();

  
  isRendering = false;
}



void RendererColoredGrid::HandleTouchMoved(ivec2 prevMouse, ivec2 mouse) {  
  Render();
}

/*
void RendererCubeMap::HandleTouchBegan(ivec2 mouse) {
  camera->moveCamZ(+.1);
  //camera->rotateCamY(40);
  //camera->moveCamX(-.1);
  
  //IntersectCube(mouse); 
}

void RendererCubeMap::HandleTouchEnded(ivec2 mouse) {
  // camera->moveCamZ(-.1);
  //camera->Reset();
  //IntersectCube(mouse); 
}

void RendererCubeMap::HandleLongPress(ivec2 mouse) {
  printf("renderer is handling LongPress gesture\n");  
  //ResourceHandler::GetResourceHandler()->ResetGyroscope();
  
  
  GLView* v = (GLView*) ResourceHandler::GetResourceHandler()->GetView();
  //GLView* v = (GLView*) view; 
  v.referenceAttitude = [v.motionManager.deviceMotion.attitude retain];
  
  camera->Reset();
  
}

void RendererCubeMap::HandlePinch(float scale) {
  printf("renderer is handling Pinch gesture\n");  
}

*/