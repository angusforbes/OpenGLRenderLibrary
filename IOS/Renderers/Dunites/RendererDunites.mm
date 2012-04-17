
#include "RendererDunites.hpp"
#include "Rectangle3D.hpp"


float PINCH_SCALE = 0.001; //0.001; //this should depend on the total number of slices
RendererDunites::RendererDunites() {
  printf("in RendererDunites constructor\n");
}

void RendererDunites::Initialize() {
    
  textureWidth = 500;
  textureHeight = 500;
  
  textures = 1; //8//number of textures to pass to fragment shader
  cols = 1; //4; //per texture
  rows = 1; //4; //per texture
  slices = cols * rows; //per texture
  
  //so... total slices = cols * rows * textures;
  
  rotVals = vec3(0,0,0);
  transVals = vec3(0,0,0); //vec3(0,0,0.5);
  scaleVal = 1.0; //0.8;
  
  
  
  printf("in RendererDunites::Initialize() : w/h = %d/%d\n", width, height); 
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
  
  //GetPrograms().insert(std::pair<string, Program*>("UnpackToBitmap", new Program("UnpackToBitmap")));
  
  //exit(0);
  
  LoadProgram("FontTexture");
  LoadProgram("SingleTexture");
  LoadProgram("NaturalMaterials");
  LoadProgram("UnpackToBitmap");
  
  
  //GetPrograms().insert(std::pair<string, Program*>("Dunite3D", new Program("NaturalMaterials")));
  //GetPrograms().insert(std::pair<string, Program*>("Dunite3D", new Program("Dunite3D")));
  
  ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  //Texture* duniteTexture = rh->LoadDunitesTexture("FILE.bmp");
  //GetTextures().insert(pair<string, Texture*>("DuniteTexture", duniteTexture));
  
  /*
  //testTex = rh->CreateTextureFromImageFile("compressTest2.png");
  testTex = rh->CreateTextureFromImageFile("hazelnut_1.png");
  // printf("testTex w/h = %d %d\n", testTex->width, testTex->height);
  
  lookupTex = rh->MakeLookupTable();
  lookupTex->SetFilterModes(GL_NEAREST, GL_NEAREST);
  
  testTex->SetFilterModes(GL_NEAREST, GL_NEAREST);
  GLubyte* compressed = rh->CompressToBits(testTex->width, testTex->height, testTex->data); 
  compressedTex = rh->CreateTextureFromBytes(testTex->width/4, testTex->height/4, compressed);
  compressedTex->SetFilterModes(GL_NEAREST, GL_NEAREST);
  
  GLubyte* uncompressed = rh->UncompressFromBits(compressedTex->width, compressedTex->height, compressedTex->data);
  uncompressedTex = rh->CreateTextureFromBytes(testTex->width, testTex->height, uncompressed);
  uncompressedTex->SetFilterModes(GL_NEAREST, GL_NEAREST);
  */
  
  naturalTextures = rh->LoadNaturalMaterialsTexture("hazelnut_.png", textureWidth, textureHeight, cols, rows, slices, textures);
  
  //CreateFBO("fboA", Texture::CreateEmptyTexture(testTex->width,testTex->height));
  // CreateFBO("fboA", Texture::CreateEmptyTexture(compressedTex->width,compressedTex->height));
  //GetFbos()["fboA"]->texture->SetFilterModes(GL_NEAREST, GL_NEAREST);
  
  
  BindDefaultFrameBuffer();
  camera->Transform();
  fullScreenRect->Transform();
}


float sssX = 0.0;
void RendererDunites::Render() { 
  
  BindDefaultFrameBuffer();
  
  bool cameraMoved = false;
  if (camera->IsTransformed()) {
    camera->Transform();
    cameraMoved = true;
  }
 
  /*
  Font font("Courier", 64);
  //Font* f1 = new Font("Courier", 64);
  Font* f2 = new Font("Helvetica", 64);
  */
  if (1 == 1) {
    
    
    FontAtlas* font = GetFont("Univers128");
    font->Bind(); {
      Text(0, sssX, "abcdefægh", vec4(1.0,0.0,0.0,0.9), false );
    } font->Unbind();
    
    font = GetFont("CMUSerifUprightItalic60");
    font->Bind(); {
      Text(sssX, 0.5, "abcdefægh", vec4(1.0,1.0,1.0,0.8) );
    } font->Unbind();
    
    Text(GetFont("CMUSerifUprightItalic128"), 100, 0.2, "12345", vec4(0.0,0.0,1.0,1.0), true);
//    GetFont("Univers128")->Text(0, 100, "abcdefægh", vec4(1.0,1.0,0.0,0.5), true );

    //f2->print(GetPrograms()["FontTexture"], camera, "xizwz12xg0", -0.0, 0.0 ,0, -1, 1.0);
//    f2->print(GetPrograms()["FontTexture"], camera, "oooooo", sssX - 1.0, 0.2 ,0, 0, 1.0);
//    f2->print(GetPrograms()["FontTexture"], camera, "111XXX", 2.0 - sssX, -0.2 ,0, 1, 1.0);
   sssX += 0.01;
//    
    sssX = fmodf((float)sssX,2.0);
//    
//    //f2->print(GetPrograms()["FontTexture"], camera, "gwiw10wer", -0.5,-0.25, 0, 0, 1.0);
    
    return;
  }  
  
  
  mat4 TextureMatrix;
  
  
  if (1 == 2) {
    TextureMatrix = mat4::Identity(); //MakeTextureMatrix();
    
    //Program* program = GetPrograms()["SingleTexture"];
    Program* program = GetPrograms()["UnpackToBitmap"];
    
    //Texture* useTex = testTex; 
    //Texture* useTex = compressedTex; 
    //Texture* useTex = uncompressedTex; 
    Texture* useTex = naturalTextures[0];
    FBO* fbo = GetFbos()["fboA"];
    fbo->Bind(); {
      program->Bind();
      
      
      set<Geom*>::iterator it;
      for (it=GetGeoms().begin(); it!=GetGeoms().end(); it++) {
        Geom* g = (Geom*) *it;
        glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, g->GetModelView().Pointer());
        glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, camera->projection.Pointer());
        glUniformMatrix4fv(program->Uniform("TextureMatrix"), 1, 0, TextureMatrix.Pointer());
        
        glUniform1f(program->Uniform("cols"), cols);
        glUniform1f(program->Uniform("rows"), rows);
        glUniform1f(program->Uniform("slices"), slices);
        glUniform1f(program->Uniform("textures"), textures);
        
        glUniform1f(program->Uniform("PackedWidth"), (float)useTex->width);
        glUniform1f(program->Uniform("PackedHeight"), (float)useTex->height);
        
        //naturalTextures[0]->Bind(GL_TEXTURE0);
        useTex->Bind(GL_TEXTURE0);
        //  glUniform1i(program->Uniform("s_tex"), 0);
        glUniform1i(program->Uniform("PackedTexture0"), 0);
        
        lookupTex->Bind(GL_TEXTURE1);
        //  glUniform1i(program->Uniform("s_tex"), 0);
        glUniform1i(program->Uniform("LookUpTexture"), 1);
        
        g->PassVertices(program, GL_TRIANGLES);
        
        useTex->Unbind(GL_TEXTURE0);
        //naturalTextures[0]->Unbind(GL_TEXTURE0);
        lookupTex->Unbind(GL_TEXTURE1);
        
      }
      
      program->Unbind();
    } fbo->Unbind();
    
    
    BindDefaultFrameBuffer();
    
    
    DrawFullScreenTexture(GetFbos()["fboA"]->texture);
    
    return;
    
  }
  
  //  Texture* duniteTexture = GetTextures()["DuniteTexture"];
  
  //  duniteTexture->SetWrapMode(GL_CLAMP_TO_EDGE);
  //  duniteTexture->SetFilterModes(GL_LINEAR, GL_LINEAR);
  
  Program* program = GetPrograms()["NaturalMaterials"];
  //Program* program = GetPrograms()["Dunite3D"];
  
  
  TextureMatrix = MakeTextureMatrix();
  
  
  
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
    
    
    glUniform1f(program->Uniform("cols"), cols);
    glUniform1f(program->Uniform("rows"), rows);
    glUniform1f(program->Uniform("slices"), slices);
    glUniform1f(program->Uniform("textures"), textures);
    
    //printf("loaded naturealTextures...0  has a texID of %d\n", naturalTextures[0]->texID);
    
    naturalTextures[0]->Bind(GL_TEXTURE0);
    glUniform1i(program->Uniform("Tex0"), 0);
    if (textures > 1) {
      naturalTextures[1]->Bind(GL_TEXTURE1);
      glUniform1i(program->Uniform("Tex1"), 1);
    }
    if (textures > 2) {
      naturalTextures[2]->Bind(GL_TEXTURE2);
      glUniform1i(program->Uniform("Tex2"), 2);
    }
    if (textures > 3) {
      naturalTextures[3]->Bind(GL_TEXTURE3);
      glUniform1i(program->Uniform("Tex3"), 3);
    }
    if (textures > 4) {
      naturalTextures[4]->Bind(GL_TEXTURE4);
      glUniform1i(program->Uniform("Tex4"), 4);
    }
    if (textures > 5) {
      naturalTextures[5]->Bind(GL_TEXTURE5);
      glUniform1i(program->Uniform("Tex5"), 5);
    }
    if (textures > 6) {
      naturalTextures[6]->Bind(GL_TEXTURE6);
      glUniform1i(program->Uniform("Tex6"), 6);
    }
    if (textures > 7) {
      naturalTextures[7]->Bind(GL_TEXTURE7);
      glUniform1i(program->Uniform("Tex7"), 7);
    }
    g->PassVertices(program, GL_TRIANGLES);
    
    naturalTextures[0]->Unbind(GL_TEXTURE0);
    if (textures > 1) {
      naturalTextures[1]->Unbind(GL_TEXTURE1);
    }
    if (textures > 2) {
      naturalTextures[2]->Unbind(GL_TEXTURE2);
    }
    if (textures > 3) {
      naturalTextures[3]->Unbind(GL_TEXTURE3);
    }
    if (textures > 4) {
      naturalTextures[4]->Unbind(GL_TEXTURE4);
    }
    if (textures > 5) {
      naturalTextures[5]->Unbind(GL_TEXTURE5);
    }
    if (textures > 6) {
      naturalTextures[6]->Unbind(GL_TEXTURE6);
    }
    if (textures > 7) {
      naturalTextures[7]->Unbind(GL_TEXTURE7);
    }
    /*
     for (int t = 0; t < textures; t++) {
     naturalTextures[t]->Bind(GL_TEXTURE0 + t);
     glUniform1i(program->Uniform("Tex" + t), t);
     }
     
     g->PassVertices(program, GL_TRIANGLES);
     
     for (int t = 0; t < textures; t++) {
     naturalTextures[t]->Unbind(GL_TEXTURE0 + t);
     }
     */
    
    /*
     duniteTexture->Bind(GL_TEXTURE0); {
     glUniform1i(program->Uniform("DuniteTexture"), 0);
     g->PassVertices(program, GL_TRIANGLES);
     } duniteTexture->Unbind(GL_TEXTURE0);
     */
  }
  
  program->Unbind();
}

mat4 RendererDunites::MakeTextureMatrix() {
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
  return TextureMatrix;
}

float prevPinchScale = -1.0;
void RendererDunites::HandlePinch(float scale) {
  
  if (prevPinchScale < 0.0) {
    prevPinchScale = 1.0;
  }
  // if (prevPinchScale < 0.0)
  //printf("scale... = %f\n", scale);
  if (scale < prevPinchScale) {  
    transVals.z -= PINCH_SCALE;
  } else {
    transVals.z += PINCH_SCALE;
  }
  
  prevPinchScale = scale;
}

void RendererDunites::HandlePinchEnded() {
  printf("ENDED!!\n");
  prevPinchScale = -1.0;
  
}


void RendererDunites::HandleTouchMoved(ivec2 prevMouse, ivec2 mouse) {
  
  
  //REAL ONE //think about...
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



