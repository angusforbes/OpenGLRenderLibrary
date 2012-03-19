
#include "RendererRayTracingChapter.hpp"



GLfloat vVertices[] = {
  -1, -1, 0.0f,  // Position 0
  0.0f,  0.0f,        // TexCoord 0 
  -1, 1, 0.0f,  // Position 1
  0.0f,  1.0f,        // TexCoord 1
  1, -1, 0.0f,  // Position 2
  1.0f,  0.0f,        // TexCoord 2
  1,  1, 0.0f,  // Position 3
  1.0f,  1.0f         // TexCoord 3
};

GLushort indices[] = { 0, 1, 2, 2, 1, 3 };

//RendererRayTracingChapter::RendererRayTracingChapter(void* _view) : Renderer(_view) {
//  
//  //CreateRenderBuffer();
//}
RendererRayTracingChapter::RendererRayTracingChapter() {
  
}

void RendererRayTracingChapter::Initialize() {
  printf("in RendererRayTracingChapter::Initialize()\n"); 
  
  prevMode = -1;
  MAX_BOUNCES = 10;
  shiny = 50.f;
  
  isRendering = false;
  isReady = false;
  
  InitializeRenderBuffers();

  //initializeRenderBuffers(&m_colorRenderbuffer, &m_depthRenderbuffer);
  
  Program* program = new Program("BasicShader");
  cout << " program ID = " << program->programID << "\n";
  GetPrograms().insert(std::pair<string, Program*>("BasicShader", program));
  
  Texture* imageTexture = Texture::CreateEmptyTexture(width, height);
  GetTextures().insert(pair<string, Texture*>("ImageTexture", imageTexture));
  
  Program* program2 = new Program("VertexLighting");
  cout << " program ID = " << program2->programID << "\n";
  GetPrograms().insert(pair<string, Program*>("VertexLighting", program2));
  
  Program* program3 = new Program("FlatLighting");
  cout << " program ID = " << program3->programID << "\n";
  GetPrograms().insert(pair<string, Program*>("FlatLighting", program3));
  
  ivec4 vp  = ivec4(0,0, width, height);  
  float near = 0.1;
  float far = 1000.0;
  vec3 cpos = vec3(0,0,0);
  camera = new Camera(cpos, 60.0, (float)width/(float)height, near, far, vp);

  spheres.resize(1);
  spheres[0] = new Sphere(vec3(-1,1,-5), 0.5);
  spheres[0]->isReflective = false;
  lights.resize(3);
  lights[0] = new Light(vec3(0,1,-4), vec3(1.0,0.0,0.0));
  lights[1] = new Light(vec3(-2,1,-5),vec3(0.0,1.0,0.0));
  lights[2] = new Light(vec3(2,1,-6), vec3(0.0,0.0,1.0));
  
  camera = new Camera(cpos, 60.0, (float)width/(float)height, near, far, vp);
  SetRenderMode(0);

  
  isReady = true;
}

int RendererRayTracingChapter::CheckShadow(vec3 point, Sphere* currentSphere, Light* l, vector<Sphere*>& spheres) {
  
  int numShadows = 0;
  
  ray3 rayToLight = ray3(point, l->GetTranslate() - point);
  
  for (int s = 0; s < spheres.size(); s++) {
    if (spheres[s] == currentSphere) {
      continue;
    }
    
    vec3 intersectsAt;
    
    if (Utils::IntersectsWithRay2(rayToLight, spheres[s], &intersectsAt) == 1) {
      if ((intersectsAt - point).Length() < rayToLight.direction.Length()) {
        numShadows++;
      }
    }
  }
  
  return numShadows;
}

vec3 RendererRayTracingChapter::CastRay(ray3 ray, Sphere* currentSphere, vector<Light*>& lights, vector<Sphere*>& spheres, int level) {
  
  vec3 ambient = vec3(.2, .2, .2);
  
  Sphere* useSphere = NULL;
  float closest = -10000;
  vec3 atNearPlane, atFarPlane, intersectsAt, useIntersect, eye, sphereNormal, lightRay, diffuseColor;
  //ray3 pixelRay;
  
  for (int i = 0; i < spheres.size(); i++) {
    if (Utils::IntersectsWithRay2(ray, spheres[i], &intersectsAt) == 1 && intersectsAt.z > closest) {
      
      //cout << atFarPlane.z << "\n";
      //printf("sphere %d, intersectAt.z = %f beating %f\n", i, intersectsAt.z, closest); 
      useSphere = spheres[i];
      useIntersect = vec3(intersectsAt);
      closest = intersectsAt.z;
    } 
  }
  
  diffuseColor = vec3(0,0,0);
  
  if (useSphere != NULL) { 
    eye = ray.direction.Normalized() * 1;//may need to reversed? (* -1) 
    sphereNormal = (useIntersect - useSphere->GetTranslate()).Normalized();
    
    
    if (useSphere->isReflective == true && level < MAX_BOUNCES) {
      
      float c1 = -vec3::Dot(sphereNormal, eye); 
      vec3 scaleN = sphereNormal * (2.0 * c1);
      vec3 r1 = eye + scaleN;       
      ray3 bounceRay = ray3(useIntersect, r1);
      return CastRay(bounceRay, useSphere, lights, spheres, level+1); 
    }
    
    //vec3 N = NormalMatrix * Normal;
    diffuseColor += ambient;
    int NUMLIGHTS = lights.size();
    for (int l = 0; l < NUMLIGHTS; l++) {
      lightRay = vec3(lights[l]->GetTranslate() - useSphere->GetTranslate()).Normalized();
      
      float diffuseLightAmount = vec3::Dot(lightRay, sphereNormal) ;
      
      if (diffuseLightAmount > 0.0) {
        if (CheckShadow(useIntersect, useSphere, lights[l], spheres) == 0) {
          
          //vec3 H1 = vec3(lightRay + eye).Normalized(); 
          vec3 H1 = vec3(lightRay + vec3(0,0,1)).Normalized(); //vec3(0,0,1));
          
          float sf1 = fmax(0.0, vec3::Dot(sphereNormal, H1));
          sf1 = powf(sf1, shiny);
          
          diffuseColor += (lights[l]->GetColor() * diffuseLightAmount); //that is, * the color of the sphere and light, etc...
          diffuseColor += vec3(.5,.5,.5) * sf1;
        }
      }
    }
  } 
  
  if (level > 0 && diffuseColor.x == 0 && diffuseColor.y == 0 && diffuseColor.z == 0) {
    return ambient;
  }
  return diffuseColor;
}

void RendererRayTracingChapter::CastRaysFromImagePlane(Camera* cam, vector<Light*>& lights, vector<Sphere*>& spheres, Texture* imageTexture) {
  ivec4 vp = cam->viewport; 
  mat4 proj = cam->projection;
  mat4 mv = cam->GetModelView();
  
  int width = vp.z;
  int height = vp.w;
  
  GLubyte* imagePlane = (GLubyte*) malloc((4*width*height)*sizeof(GLubyte));
  
  int idx = 0;                    
  int red, blue, green = 0;
  
  vec3 atNearPlane, atFarPlane, intersectsAt, useIntersect, eye, sphereNormal, lightRay;
  ray3 pixelRay;
  
  for (int y = height-1; y >= 0; y--) {
    for (int x = 0; x < width; x++) {
      
      atNearPlane = mat4::Unproject(x, y, 0.0, mv, proj, vp);
      atFarPlane = mat4::Unproject( x, y, 1.0, mv, proj, vp);
      pixelRay = ray3(atNearPlane, (atFarPlane - atNearPlane));
      
      vec3 pixelColor = CastRay(pixelRay, NULL, lights, spheres, 0);
      
      red   = fmin(255, (int) fabs((pixelColor.x) * 255.0));
      green = fmin(255, (int) fabs((pixelColor.y) * 255.0));
      blue  = fmin(255, (int) fabs((pixelColor.z) * 255.0));
      
      imagePlane[idx] = red;
      imagePlane[idx+1] = green;
      imagePlane[idx+2] = blue;
      imagePlane[idx+3] = 255;
      
      idx+=4;
    }
  }
  
  imageTexture->Bind(GL_TEXTURE0);
  glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, imagePlane);
  imageTexture->Unbind(GL_TEXTURE0);
  
}



int RendererRayTracingChapter::GetRenderMode() {
  return mode;
}

void RendererRayTracingChapter::SetRenderMode(int _mode) {
  //printf("setting render mode to %d\n", _mode);
  //can only be 0 (openGL) or 1 (raytrace)
  mode = _mode;
}

vector<Light*>& RendererRayTracingChapter::GetLights() { 
  return lights;
}
vector<Sphere*>& RendererRayTracingChapter::GetSpheres() { 
  return spheres;
}


void RendererRayTracingChapter::Render() { 
  
  
  
  if (!isReady) {
    printf("not ready yet!\n");
    return;
  }
  
  isRendering = true;
  
  vector<Sphere*> spheres = GetSpheres();
  vector<Light*> lights = GetLights();
  
  int mode = GetRenderMode();
  
  Camera* cam = GetCamera();
  bool cameraMoved = false;
  
  if (mode != prevMode || cam->IsTransformed() == true) {
    cameraMoved = true;
    cam->Transform();
    prevMode = mode;
  }
  
  for (int i = 0; i < spheres.size(); i++) {
    if (spheres[i]->IsTransformed() == true || cameraMoved == true) {
      spheres[i]->Transform();
    }
  }
  
  for (int i = 0; i < lights.size(); i++) {
    if (lights[i]->IsTransformed() == true || cameraMoved == true) {
      lights[i]->Transform();
    }
  }
  
  cameraMoved = false;
  
  
  
  glViewport(cam->viewport.x, cam->viewport.y, cam->viewport.z, cam->viewport.w);
  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  
  
  if (mode == 1) {
    
    Texture* tex = GetTextures()["ImageTexture"];
    
    CastRaysFromImagePlane(cam, lights, spheres, tex);
    
    Program* program = GetPrograms()["BasicShader"];
    
    //glDisable(GL_DEPTH_TEST);
    program->Bind();
    
    tex->Bind(GL_TEXTURE0);
    
    glUniform1i(program->Uniform("s_tex"), 0);
    
    for (int i = 0; i < 20; i+=5) {
      //printf("vertex : %f/%f/%f : %f/%f \n", vVertices[i], vVertices[i+1], vVertices[i+2], vVertices[i+3], vVertices[i+4]);
    }
    
    glVertexAttribPointer ( program->Attribute("position"), 3, GL_FLOAT, 
                           GL_FALSE, 5 * sizeof(GLfloat), vVertices );
    glVertexAttribPointer ( program->Attribute("texCoord"), 2, GL_FLOAT,
                           GL_FALSE, 5 * sizeof(GLfloat), &vVertices[3] );
    
    glEnableVertexAttribArray ( program->Attribute("position") );
    glEnableVertexAttribArray ( program->Attribute("texCoord") );
    
    
    glDrawElements ( GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices );
    
    
    glDisableVertexAttribArray ( program->Attribute("position") );
    glDisableVertexAttribArray ( program->Attribute("texCoord") );
    
    tex->Unbind(GL_TEXTURE0);
    program->Unbind();
    
    
  } else {
    for (int i = 0; i < lights.size(); i++) {
      Program* program = GetPrograms()["FlatLighting"];
      glUseProgram(program->programID);
      glDisable(GL_DEPTH_TEST); 
      
      mat4 sphereModelView = lights[i]->GetModelView();       
      
      glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, sphereModelView.Pointer());
      glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, cam->projection.Pointer());
      glUniform3fv(program->Uniform("Color"), 1, lights[i]->GetColor().Pointer());
      
      glEnableVertexAttribArray ( program->Attribute("Position") );
      
      int stride = 6 * sizeof(GLfloat);
      glVertexAttribPointer( program->Attribute("Position"), 3, GL_FLOAT, GL_FALSE, stride, &lights[i]->vertices[0] );
      
      glDrawElements ( GL_TRIANGLES, lights[i]->GetTriangleIndexCount(), GL_UNSIGNED_SHORT, &lights[i]->triangleIndices[0] );
      
      glDisableVertexAttribArray ( program->Attribute("Position") );
      program->Unbind();
    }
    
    for (int i = 0; i < spheres.size(); i++) {
      
      Program* program = GetPrograms()["VertexLighting"];
      glUseProgram(program->programID);
      glEnable(GL_DEPTH_TEST); 
      
      vec3 lt0 = lights[0]->GetTranslate() - spheres[i]->GetTranslate();
      vec3 lt1 = lights[1]->GetTranslate() - spheres[i]->GetTranslate();
      vec3 lt2 = lights[2]->GetTranslate() - spheres[i]->GetTranslate();
      
      vec3 lc0 = lights[0]->GetColor();
      vec3 lc1 = lights[1]->GetColor();
      vec3 lc2 = lights[2]->GetColor();
      
      glUniform3f(program->Uniform("LightPosition1"), lt0.x, lt0.y, lt0.z);
      glUniform3f(program->Uniform("LightColor1"), lc0.x, lc0.y, lc0.z);
      glUniform3f(program->Uniform("LightPosition2"), lt1.x, lt1.y, lt1.z);
      glUniform3f(program->Uniform("LightColor2"), lc1.x, lc1.y, lc1.z);
      glUniform3f(program->Uniform("LightPosition3"), lt2.x, lt2.y, lt2.z);
      glUniform3f(program->Uniform("LightColor3"), lc2.x, lc2.y, lc2.z);
      
      mat3 normalMatrix = mat4::Translate(cam->GetTranslate()).ToMat3();
      //mat3 normalMatrix = mat4::Identity().ToMat3(); //Translate(cam->GetTranslate()).ToMat3();
      //mat3 normalMatrix = (spheres[i]->GetModelView()).ToMat3();
      
      mat4 sphereModelView = spheres[i]->GetModelView();       
      
      glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, sphereModelView.Pointer());
      glUniformMatrix3fv(program->Uniform("NormalMatrix"), 1, 0, normalMatrix.Pointer());
      glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, cam->projection.Pointer());
      
      glVertexAttrib3fv(program->Attribute("DiffuseMaterial"), spheres[i]->GetColor().Pointer());
      //glUniform3f(program->Uniform("DiffuseMaterial"), 1.0f, 1.0f, 0.5f);
      
      glUniform3f(program->Uniform("AmbientMaterial"), 0.2f, 0.2f, 0.2f);
      glUniform3f(program->Uniform("SpecularMaterial"), 0.5, 0.5, 0.5);
      glUniform1f(program->Uniform("Shininess"), shiny);
      
      
      glEnableVertexAttribArray ( program->Attribute("Position") );
      glEnableVertexAttribArray ( program->Attribute("Normal") );
      
      int stride = 6 * sizeof(GLfloat); //2 * sizeof(vec3); //6 * sizeof(GLfloat);
      glVertexAttribPointer( program->Attribute("Position"), 3, GL_FLOAT, 
                            GL_FALSE, stride, &spheres[i]->vertices[0] );
      glVertexAttribPointer( program->Attribute("Normal"), 3, GL_FLOAT, 
                            GL_FALSE, stride, &spheres[i]->vertices[3] );
      
      
      int indexCount = spheres[i]->GetTriangleIndexCount();
      
//              printf("indexCount = %d\n", indexCount);
//              for (int nnn = 0; nnn < indexCount; nnn++) {
//                printf("%d : %hu\n", nnn, spheres[i]->triangleIndices[nnn]); }
              
      glDrawElements( GL_TRIANGLES, indexCount, GL_UNSIGNED_SHORT, &spheres[i]->triangleIndices[0] );
      
      glDisableVertexAttribArray ( program->Attribute("Position") );
      glDisableVertexAttribArray ( program->Attribute("Normal") );
      
      program->Unbind();
    }
    
    
  }
  
  isRendering = false;
  
  
}


void RendererRayTracingChapter::HandleTouchBegan(ivec2 location) {
  
  printf("renderer is handling TouchBegan\n");
  
  ivec4 vp = GetCamera()->viewport; 
  mat4 proj = GetCamera()->projection;
  
  mat4 mv = GetCamera()->GetModelView();
  vec3 atNearPlane = mat4::Unproject(location.x, location.y, 0.0, mv, proj, vp);
  vec3 atFarPlane = mat4::Unproject(location.x, location.y, 1.0, mv, proj, vp);
  vec3 d = atFarPlane - atNearPlane;
  ray3 theRay = ray3(atNearPlane, (atFarPlane - atNearPlane));
  
  for (int i = 0; i < spheres.size(); i++) {
    vec3 intersectsAt = vec3();
    int doesIntersect = Utils::IntersectsWithRay2(theRay, spheres[i], &intersectsAt);
    
    if (doesIntersect == 0) {
      spheres[i]->SetColor(vec3(1.0,0.0,0.0));
    } else {
      selectedSphere = spheres[i];
      sphereIsSelected = true;
      spheres[i]->SetColor(vec3(0.0,0.0,1.0));        
    }
  }
  
  for (int i = 0; i < lights.size(); i++) {
    vec3 intersectsAt = vec3();
    int doesIntersect = Utils::IntersectsWithRay2(theRay, lights[i], &intersectsAt);
    
    if (doesIntersect == 0) {
      //lights[i]->SetColor(vec3(1.0,0.0,0.0));
      lights[i]->SetScale(0.1);
      
    } else {
      selectedSphere = lights[i];
      sphereIsSelected = true;
      lights[i]->SetScale(0.3);
      //lights[i]->SetColor(vec3(1.0,1.0,1.0));        
    }
  }
  
  mode = 0; //opengl
  

}

void RendererRayTracingChapter::HandleTouchMoved(ivec2 oldLocation, ivec2 location) {
  
  printf("renderer is handling TouchMoved\n");

  
  mode = 0; //opengl
  ivec4 vp = GetCamera()->viewport; 
  mat4 proj = GetCamera()->projection; 
  
  if (sphereIsSelected == true) {
    mat4 mv = mat4::Translate(GetCamera()->GetTranslate()); //get cameras modelview (i.e., parent of sphere)
    
    float sphereDepth = mat4::GetDepth(selectedSphere->GetTranslate(), mv, proj, vp);
    vec3 atSpherePlane = mat4::Unproject(location.x, location.y, sphereDepth, mv, proj, vp);
    
    selectedSphere->SetTranslate(vec3(atSpherePlane));
  }
  
  float ydiff = oldLocation.y - location.y;
  float xdiff = oldLocation.x - location.x;
  
  if (abs(ydiff) > abs(xdiff)) {
    GetCamera()->RotateX(ydiff);
  } else {
    GetCamera()->RotateY(xdiff);
  }

}



