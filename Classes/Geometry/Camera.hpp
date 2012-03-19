//#include "GLView.h"

#include "Vector.hpp"
#include "Matrix.hpp"
#include "ModelView.hpp"
//#include "Utils.hpp"


#ifndef CAMERA_H
#define CAMERA_H





class Camera : public ModelView {
  
  
public:
  Camera(vec3 translate, float fovy, float aspect, float nearPlane, float farPlane, ivec4 _viewport);
  Camera(ivec4 _viewport);
  float fovy; //field of view angle, in	degrees, in the y	direction.
  float aspect; //the	aspect ratio that determines the field of view in the x direction. The aspect ratio is the ratio	of x (width) to	y (height).
  float nearPlane; //the	distance from the viewer to the	near clipping plane (always positive).
  float farPlane; //the	distance from the viewer to the	far clipping plane (always positive).
  mat4 projection;
  ivec4 viewport; //lowerLeft.x, lowerLeft.y, width, height
  void Transform();
  
  void SetViewport(ivec4 viewport);
  void SetAspectRatio(float _aspect);
  void Reshape(int width, int height);
  
  
  mat4 LookAt(float eyex, float eyey, float eyez,
              float centerx, float centery, float centerz,
              float upx, float upy, float upz);
  void rotateCamX(float angle);
  void rotateCamY(float angle);
  void rotateCamZ(float angle);
  void moveCam(vec3 distVec);
  void moveCamX( float dist );
  void moveCamY( float dist );
  void moveCamZ( float dist );
  void RenderCam();
  
  void Zoom(float dist);
  void Reset();
  
  vec3 posVec;
  
  void SetGyroscopeMatrix(mat4 gm);
  mat4 GetGyroscopeMatrix();
  

private:
  
  bool IsPerspective;
  mat4 gyroscopeMatrix;
  
  vec3 viewVec;
  vec3 rightVec;
  vec3 upVec;
  
};

#endif