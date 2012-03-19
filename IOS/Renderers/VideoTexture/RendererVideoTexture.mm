
#include "RendererVideoTexture.hpp"

string VIDEO_FILENAME = "FA-demo1.m4v";


RendererVideoTexture::RendererVideoTexture() {
  printf("in RendererVideoTexture constructor\n");
}

void RendererVideoTexture::Initialize() {
  
  printf("in RendererVideoTexture::Initialize()\n"); 
  SetCamera(new Camera(ivec4(0, 0, width, height)));
  
  Rectangle* r1 = new Rectangle(); //vec3(-2.0, -1.0, 0.0), 4.0, 2.0);
  r1->SetTranslate(vec3(-.5,-.5,0));
  r1->SetScaleAnchor(vec3(0.5, 0.5, 0.0));
  r1->SetScale(vec3(1.8, 1.0, 1.0));
  AddGeom(r1);
  r1->Transform();
  
  Program* program = new Program("SingleTexture");
  cout << " program ID = " << program->programID << "\n";
  GetPrograms().insert(std::pair<string, Program*>("SingleTexture", program));
  
  BindDefaultFrameBuffer();
  
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  Texture* videoTexture = rh->CreateVideoTexture(VIDEO_FILENAME);
  GetTextures().insert(pair<string, Texture*>("VideoTexture", videoTexture));
  
  Texture* noiseTexture = Texture::CreateColorNoiseTexture(50,50);
  GetTextures().insert(pair<string, Texture*>("noiseTexture", noiseTexture));
  
}


void RendererVideoTexture::Render() { 
  
   
  Texture* videoTexture = GetTextures()["VideoTexture"];
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  //rh->HandlePlayback(videoTexture, true);
  rh->NextVideoFrame();
  
  //Texture* videoTexture = GetTextures()["noiseTexture"];
  
  Program* program = GetPrograms()["SingleTexture"];
  
  program->Bind();
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
  
  set<Geom*>::iterator it;
  for (it=GetGeoms().begin(); it!=GetGeoms().end(); it++) {
    Geom* g = (Geom*) *it;
    glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, g->GetModelView().Pointer());
    glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());

    videoTexture->Bind(GL_TEXTURE0); {
      glUniform1i(program->Uniform("s_tex"), 0);
      g->PassVertices(program, GL_TRIANGLES);
    } videoTexture->Unbind(GL_TEXTURE0);
  }

  program->Unbind();
  

}


