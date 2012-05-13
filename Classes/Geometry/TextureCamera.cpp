#include "TextureCamera.hpp"
#include "Utils.hpp"
#include <glm/gtc/matrix_transform.hpp>


//Rectangular Texture Camera
//produces a modelview matrix that can be used to reposition vertexes around a camera view

TextureCamera::TextureCamera() {
  initPosVec = vec3(0,0,0);
  initRotVec = vec3(0,0,0);
  initScaleVec = vec3(1,1,0);
  rotateAnchor = vec3(0.5,0.5,0.0);
  scaleAnchor = vec3(0.5,0.5,0.0);
  
  Reset();
}

TextureCamera::TextureCamera(vec3 _initPosVec, vec3 _initRotVec, vec3 _initScaleVec) {
  
  initPosVec = _initPosVec;
  initRotVec = _initRotVec;
  initScaleVec = _initScaleVec;
  rotateAnchor = vec3(0.5,0.5,0.0);
  scaleAnchor = vec3(0.5,0.5,0.0);
  
  Reset();
  
}
void TextureCamera::Transform() {
  
  if (IsTransformed()) {
    mat4 tm = mat4(); //::Identity();
    mat4 rotBasis = MakeCameraBasis();
    
    
    tm = glm::translate(tm, vec3(-posVec.x, -posVec.y, -posVec.z));
    
    tm = glm::translate(tm, scaleAnchor);
    tm = glm::scale(tm, scale);
    tm = glm::translate(tm, -scaleAnchor);
    
    tm = glm::translate(tm, rotateAnchor);
    tm = rotBasis * tm;
    tm = glm::translate(tm, -rotateAnchor);
    /*
    tm = mat4::Translate(tm, vec3(-posVec.x, -posVec.y, -posVec.z));
    
    tm = mat4::Translate(tm, scaleAnchor);
    tm = mat4::Scale(tm, scale);
    tm = mat4::Translate(tm, -scaleAnchor);
    
    tm = mat4::Translate(tm, rotateAnchor);
    tm = mat4(rotBasis) * tm;
    tm = mat4::Translate(tm, -rotateAnchor);
    */
    SetModelView(tm);
    SetIsTransformed(false);
  } 
}

/*
 
 //PANA
 //  //THIS seems to work for the Panoramic Video...
 //  mat4 transformedMatrix = mat4::Identity();
 //  //transformedMatrix *= mat4(m);
 //  transformedMatrix = mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));
 //
 //  transformedMatrix = mat4::Translate(transformedMatrix, vec3(0.5, 0.5, 0.5));
 //  transformedMatrix = mat4::Scale(transformedMatrix, vec3(sx,sy,sz));
 //  transformedMatrix = mat4::Translate(transformedMatrix, -vec3(0.5, 0.5, 0.5));
 //END Panoramic Video
 */

void TextureCamera::Reset() {
  //Camera::Reset();
  posVec = initPosVec;
  
  mat4 rot = mat4(); //::Identity();
  rot = glm::rotate(rot, initRotVec.x, vec3(1,0,0));
  rot = glm::rotate(rot, initRotVec.y, vec3(0,1,0));
  rot = glm::rotate(rot, initRotVec.z, vec3(0,0,1));
  
  rightVec = rot[0].xyz(); //vec3(rot.x.x, rot.x.y, rot.x.z);
  upVec = rot[1].xyz(); //vec3(rot.y.x, rot.y.y, rot.y.z);
  viewVec = rot[2].xyz(); //vec3(rot.z.x, rot.z.y, rot.z.z);
  
  /*
  mat4 rot = mat4::Identity();
  rot = mat4::RotateX(rot, initRotVec.x);
  rot = mat4::RotateY(rot, initRotVec.y);
  rot = mat4::RotateZ(rot, initRotVec.z);
  
  rightVec = vec3(rot.x.x, rot.x.y, rot.x.z);
  upVec = vec3(rot.y.x, rot.y.y, rot.y.z);
  viewVec = vec3(rot.z.x, rot.z.y, rot.z.z);
  */
  
  scale = initScaleVec;
  
  SetIsTransformed(true); 
  Transform();
}

