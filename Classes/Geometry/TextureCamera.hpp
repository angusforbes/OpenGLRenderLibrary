//#include "GLView.h"

#include "Vector.hpp"
#include "Matrix.hpp"
#include "ModelView.hpp"
//#include "Utils.hpp"


#ifndef TEXTURE_CAMERA_H
#define TEXTURE_CAMERA_H





class TextureCamera : public ModelView {
  
  
public:
  TextureCamera();
  void Transform();
  
  mat4 LookAt(float eyex, float eyey, float eyez,
              float centerx, float centery, float centerz,
              float upx, float upy, float upz,
              float sx, float sy, float sz
              );
  void rotateCamX(float angle);
  void rotateCamY(float angle);
  void rotateCamZ(float angle);
  void moveCam(vec3 distVec);
  void moveCamX( float dist );
  void moveCamY( float dist );
  void moveCamZ( float dist );
  void RenderCam();
  
 // void Zoom(float dist);
  void Reset();
  
  vec3 posVec;
  vec3 viewVec;
  vec3 rightVec;
  vec3 upVec;
  
  void SetGyroscopeMatrix(mat4 gm);
  mat4 GetGyroscopeMatrix();
  

private:
  
  mat4 gyroscopeMatrix;
  
 
  
};

#endif