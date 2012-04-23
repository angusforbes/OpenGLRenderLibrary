#include "Camera.hpp"


//Orthographic Camera
Camera::Camera(ivec4 _viewport) {
  
  IsPerspective = false;

  aspect = (float)_viewport.z/(float)_viewport.w;
  //SetTranslate(vec3());
  SetViewport(_viewport);
  
  //projection = mat4::Identity(); 
  projection = mat4::Ortho(0, 1, 0, 1); 
  //projection = mat4::Ortho(_viewport.z, _viewport.w); 
  
  //projection = mat4::Ortho(0, _viewport.z, _viewport.w, 0); 
  
  //vector camera init
  posVec = vec3(0.0, 0.0, 0.0);
  viewVec = vec3(0.0, 0.0f, -1.0);
  rightVec = vec3(1.0, 0.0, 0.0);
  upVec = vec3(0.0, 1.0, 0.0);  
  
  
  //TEST for otho/pixel
//  mat4 i = mat4::Identity();
//  i = mat4::Translate(i,0,500,0);
//  SetModelView(i);
  
}

/*
Camera* Camera::CreateOrthographicCamera(float _fovy, ivec4 _vp) { }

Camera* Camera::CreateOrthographicPixelCamera(float _fovy, ivec4 _vp) { }
*/

Camera* Camera::CreatePerspectiveCamera(float _fovy, ivec4 _vp) {
  
  float ar = 1.0; 
  float uw = 1.0; 
  float uh = 1.0; 
  
  float rads = radians(_fovy) / 2.0;
  float cameraZ = ((uh/2.0) / tanf(rads));
  float near = cameraZ/10.0;
  float far = cameraZ*10.0;
  
  return new Camera(vec3(uw/2.0, uh/2.0, -cameraZ), _fovy, ar, near, far, _vp );
}

//taken from Fry's Processing code. Objects placed at z=0 line up with pixels
Camera* Camera::CreatePerspectivePixelCamera(float _fovy, ivec4 _vp) {
  
  float ar = (float)_vp.z/(float)_vp.w;
  
  float uw = _vp.z; //width
  float uh = _vp.w; //height
  
  float rads = radians(_fovy) / 2.0;
  float cameraZ = ((uh/2.0) / tanf(rads));
  float near = cameraZ/10.0;
  float far = cameraZ*10.0;
  
  return new Camera(vec3(uw/2.0, uh/2.0, -cameraZ), _fovy, ar, near, far, _vp );
}

//Perspective Camera
Camera::Camera(vec3 _translate, float _fovy, float _aspect, float _nearPlane, float _farPlane, ivec4 _viewport) {
  
  IsPerspective = true;
  
  //SetTranslate(_translate);
  
  
  fovy = _fovy;
  aspect = _aspect;
  nearPlane = _nearPlane;
  farPlane = _farPlane;
  SetViewport(_viewport);

  projection = mat4::Perspective(fovy, aspect, nearPlane, farPlane);  
  
  //vector camera init
  posVec = vec3(0.0, 0.0, 0.0);
  viewVec = vec3(0.0, 0.0f, -1.0);
  rightVec = vec3(1.0, 0.0, 0.0);
  upVec = vec3(0.0, 1.0, 0.0);  
  
  moveCam(_translate);
}



bool Camera::AddGeom(Geom* _g) {
  printf("in Camera::AddGeom(Geom* g) \n");

  _g->parent = this;
  _g->root = (Camera*)this;
  geoms.push_back(_g);
  //geoms.insert(0,_g);
  return 1; //later make a real test- ie if it's already in there...
}


void Camera::Draw() {
  ivec4 vp = viewport;
  glViewport(vp.x, vp.y, vp.z, vp.w);
}

void Camera::Render() { 
  bool cameraMoved = false;
  if (IsTransformed()) {
    cameraMoved = true;
  }
  
  RenderChildren(this, cameraMoved);
}


void Camera::RenderChildren(Geom* parent, bool cameraMoved) {
 
  if (cameraMoved == true || parent->IsTransformed() == true) {
    parent->Transform();
  }
  parent->Draw();
  
  vector<Geom*>::iterator it;
  for (it=parent->geoms.begin(); it!=parent->geoms.end(); it++) {
    RenderChildren((Geom*) *it, cameraMoved);
  }
}


ivec2 Camera::Project(vec3 p) {
  vec3 wp = mat4::Project(p, modelview, projection, viewport);
  return ivec2(wp.x, viewport.w - wp.y);
}


void Camera::Reshape(int width, int height) {
  SetAspectRatio((float)width/(float)height);
  SetViewport(ivec4(0,0,width,height));
  if (IsPerspective) {
    projection = mat4::Perspective(fovy, aspect, nearPlane, farPlane);  
    printf("updating projection matrix\n");
  }
  printf("in Camera::Reshape %d %d\n", width, height);
}

void Camera::SetAspectRatio(float _aspect) {
  printf("in Camera::SetAspect\n");
  aspect = _aspect;
}

void Camera::SetViewport(ivec4 _viewport) {
  printf("in Camera::SetViewport\n");
  viewport = _viewport;
}

void Camera::Transform() {
  
 // printf("in Camera::Transform()\n");
  
  //hmm
  //rotx, roty, rotz, then trans?
  /*
  modelview = MatrixUtils.translate(modelview, rotateAnchor.x, rotateAnchor.y, rotateAnchor.z);
  modelview = MatrixUtils.rotate(modelview, rotate.x, 1f, 0f, 0f);
  modelview = MatrixUtils.rotate(modelview, rotate.y, 0f, 1f, 0f);
  modelview = MatrixUtils.rotate(modelview, rotate.z, 0f, 0f, 1f);
  modelview = MatrixUtils.translate(modelview, -rotateAnchor.x, -rotateAnchor.y, -rotateAnchor.z);
  */ 
   
  
  // REAL ONE //
  /*
  mat4 mv = mat4::Identity();
//  mv = mat4::RotateX(mv, GetRotate().x);
//  mv = mat4::RotateY(mv, GetRotate().y);
//  mv = mat4::RotateZ(mv, GetRotate().z);
 
  mv = mat4::Translate(mv, GetTranslate());
  
  SetModelView(mv);
  SetIsTransformed(false);
  */
  
  //LookAt Cam
  
  RenderCam();
  //RenderCam2();
  
}

void Camera::rotateCamX (float angle) {
   
  //Rotate viewdir around the right vector:
  vec3 tmp1 = vec3(viewVec); 
  tmp1 *= (float)cosf(radians(angle)); 
  vec3 tmp2 = vec3(upVec);
  tmp2 *= (float)sinf(radians(angle));
  tmp1 += tmp2;
  
  viewVec = tmp1.Normalized();
  //viewVec.Normalize();	
  
 
  //now compute the new RightVector (by cross product)
  //rightVec = vec3::Cross(upVec, viewVec);
  //rightVec *= -1;
  upVec = vec3::Cross(viewVec, rightVec);
  upVec *= -1;
  
//  cout << "vv = " << viewVec.String() << "\n";  
//  cout << "rv = " << rightVec.String() << "\n";  
//  cout << "uv = " << upVec.String() << "\n";  

  
  //upVec.cross(viewVec, rightVec);
  //upVec.scale(-1f);
  SetIsTransformed(true);
}

void Camera::rotateCamY (float angle)
{
  //rotCamY += angle;
  
  //Rotate viewdir around the up vector:
  vec3 tmp1 = vec3(viewVec); 
  tmp1 *= (float)cosf(radians(angle)); 
  vec3 tmp2 = vec3(rightVec);
  tmp2 *= (float)sinf(radians(angle));
  tmp1 -= tmp2;
  
  //viewVec = tmp1.Normalized();
  viewVec = tmp1;
  
  
  //now compute the new UpVector (by cross product)
  //rightVec = vec3::Cross(upVec, viewVec);
  rightVec = vec3::Cross(viewVec, upVec);
  //rightVec.cross(viewVec, upVec);
 
  // rightVec *= -1.0;
  cout << "vv = " << viewVec.String() << "\n";  
  cout << "rv = " << rightVec.String() << "\n";  
  cout << "uv = " << upVec.String() << "\n";  

  //RenderCam();
  SetIsTransformed(true);

}

void Camera::rotateCamZ (float angle)
{
  //rotCamZ += angle;
 
  //Rotate viewdir around the right vector:
  
  vec3 tmp1 = vec3(rightVec); 
  tmp1 *= (float)cosf(radians(angle)); 
  vec3 tmp2 = vec3(upVec);
  tmp2 *= (float)sinf(radians(angle));
  tmp1 += tmp2;
  
  rightVec = tmp1.Normalized();
  
  upVec = vec3::Cross(viewVec, rightVec);
  upVec *= -1.0;
  
 
  SetIsTransformed(true);
}

mat4 Camera::LookAt(float eyex, float eyey, float eyez,
                    float centerx, float centery, float centerz,
                    float upx, float upy, float upz) {
  
  float m[16];
  float x[3], y[3], z[3];
  float mag;
  
  /* Make rotation matrix */
  
  /* Z vector */
  z[0] = eyex - centerx;
  z[1] = eyey - centery;
  z[2] = eyez - centerz;
  mag = sqrt(z[0] * z[0] + z[1] * z[1] + z[2] * z[2]);
  if (mag) {          /* mpichler, 19950515 */
    z[0] /= mag;
    z[1] /= mag;
    z[2] /= mag;
  }
  
  /* Y vector */
  y[0] = upx;
  y[1] = upy;
  y[2] = upz;
  
  /* X vector = Y cross Z */
  x[0] = y[1] * z[2] - y[2] * z[1];
  x[1] = -y[0] * z[2] + y[2] * z[0];
  x[2] = y[0] * z[1] - y[1] * z[0];
  
  /* Recompute Y = Z cross X */
  y[0] = z[1] * x[2] - z[2] * x[1];
  y[1] = -z[0] * x[2] + z[2] * x[0];
  y[2] = z[0] * x[1] - z[1] * x[0];
  
  /* mpichler, 19950515 */
  /* cross product gives area of parallelogram, which is < 1.0 for
   * non-perpendicular unit-length vectors; so normalize x, y here
   */
  
  mag = sqrt(x[0] * x[0] + x[1] * x[1] + x[2] * x[2]);
  if (mag) {
    x[0] /= mag;
    x[1] /= mag;
    x[2] /= mag;
  }
  
  mag = sqrt(y[0] * y[0] + y[1] * y[1] + y[2] * y[2]);
  if (mag) {
    y[0] /= mag;
    y[1] /= mag;
    y[2] /= mag;
  }
  
#define M(row,col)  m[col*4+row]
  M(0, 0) = x[0];
  M(0, 1) = x[1];
  M(0, 2) = x[2];
  M(0, 3) = 0.0;
  M(1, 0) = y[0];
  M(1, 1) = y[1];
  M(1, 2) = y[2];
  M(1, 3) = 0.0;
  M(2, 0) = z[0];
  M(2, 1) = z[1];
  M(2, 2) = z[2];
  M(2, 3) = 0.0;
  M(3, 0) = 0.0;
  M(3, 1) = 0.0;
  M(3, 2) = 0.0;

  M(3, 3) = 1.0;
#undef M
  
  /*
  mat4 transformedMatrix = mat4::Identity();
 
  
 // transformedMatrix = mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));
  
  transformedMatrix = mat4::Translate(transformedMatrix, -vec3(0.5,0.5,0.0));
  
  transformedMatrix *= mat4(m);
  transformedMatrix = mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));
  
  //transformedMatrix = mat4::Translate(transformedMatrix, -vec3(0.5,0.5,0.0));
  
  
  
  return transformedMatrix;
  */
  //cout << "eyeVec = " << vec3(-eyex, -eyey, -eyez).String() << "\n";

  mat4 transformedMatrix = mat4(m);
  return mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));
  
}



void Camera::moveCamX(float dist) {
  posVec += (vec3(rightVec) * dist);
  SetIsTransformed(true);
}

void Camera::moveCamY(float dist) {
  posVec += (vec3(upVec) * dist);
  SetIsTransformed(true);
}

void Camera::moveCamZ(float dist) {
  posVec += (vec3(viewVec) * dist);
  SetIsTransformed(true);
}

void Camera::moveCam(vec3 dist) {
  moveCamX(dist.x);
  moveCamY(dist.y);
  moveCamZ(dist.z);
}

float zoomAmt = 0.0;

float tmpRotAmt = 0.0;
float tmpZoomAmt = 0.0;
void Camera::Zoom(float dist) {
  tmpRotAmt = 45.0;
  tmpZoomAmt -= dist;
  
  modelview = mat4::Identity();
  //vec3 vV = vec3(modelview.z.x, modelview.z.y, modelview.z.z) * dist;
  mat4 rotateM = mat4::Rotate(tmpRotAmt, vec3(0.0, 1.0, 0.0));  
  rotateM.Print();

  mat4 transM = mat4::Translate(0,0,tmpZoomAmt);  
  transM.Print();
  
  modelview = modelview * rotateM;
  vec3 vV = vec3(modelview.z.x, modelview.z.y, modelview.z.z) * tmpZoomAmt;
  modelview.z.x = vV.x;
  modelview.z.y = vV.y;
  modelview.z.z = vV.z;
  
  // modelview = modelview * transM;
  
  //modelview =  rotateM * transM;
  //modelview =   transM * rotateM;
  modelview.Print();
  SetIsTransformed(true);  

  //2, 6, 10
  
}

void Camera::Reset() {
  
  posVec = vec3(0.0, 0.0, 0.0);
  viewVec = vec3(0.0, 0.0f, -1.0);
  rightVec = vec3(1.0, 0.0, 0.0);
  upVec = vec3(0.0, 1.0, 0.0);  
  SetGyroscopeMatrix(mat4()); //reset rotation matrix to identity

  modelview = mat4::Identity();
  
  
  SetIsTransformed(true); 
}

void Camera::RenderCam() {
//  printf("in Camera::RenderCam()\n");
  //real one for incremental rotates... 
  
  
  //viewpoint is the point at which the camera looks:
  vec3 viewpoint = vec3(posVec) + viewVec;
  
 
  
  mat4 transformedMatrix = LookAt (
   posVec.x, posVec.y, posVec.z,
   viewpoint.x, viewpoint.y, viewpoint.z,
   upVec.x, upVec.y, upVec.z
   );
  SetModelView(transformedMatrix);
//  printf("in Camera::RenderCam()\n");
//  modelview.Print();
  SetIsTransformed(false);
  
 /* 
  //TEST for otho/pixel
  mat4 i = mat4::Identity();
  i = mat4::Translate(i,0,1024,0);
  SetModelView(i);
  */
 /* 
    //gyroscope one ... can't do incremental rotations, so only makes sense to 
  //reset to identity at each frame , ie not a full vector camera
  mat4 tm = mat4::Translate(posVec);
  mat4 gm = GetGyroscopeMatrix() * tm;
  mat4 mv = gm;
  SetModelView(mv);
  SetIsTransformed(false);  
  */ 
}

void Camera::SetGyroscopeMatrix(mat4 gm) {
  //SetIsTransformed(true);
  //gyroscopeMatrix = gm;
}

mat4 Camera::GetGyroscopeMatrix() {
  return gyroscopeMatrix;
}


