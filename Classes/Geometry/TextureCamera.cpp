#include "TextureCamera.hpp"

//Orthographic Texture Camera
TextureCamera::TextureCamera() {
  
  //vector camera init
  posVec = vec3(0.0, 0.0, 0.0);
  viewVec = vec3(0.0, 0.0f, -1.0);
  rightVec = vec3(1.0, 0.0, 0.0);
  upVec = vec3(0.0, 1.0, 0.0);    
}


void TextureCamera::rotateCamX (float angle) {
   
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

void TextureCamera::rotateCamY (float angle)
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

void TextureCamera::rotateCamZ (float angle)
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

mat4 TextureCamera::LookAt(float eyex, float eyey, float eyez,
                    float centerx, float centery, float centerz,
                    float upx, float upy, float upz,
                    float sx, float sy, float sz) {
  
  
 // printf("1..... here...\n");
  
  float m[16];
  float x[3], y[3], z[3];
  float mag;
  
  /* Make rotation matrix */
  
  /* Z vector */
  z[0] = eyex - centerx;
  z[1] = eyey - centery;
  z[2] = eyez - centerz;
  
 // float zang = atan2(z[1],z[0]) - atan2(0.0,1.0);
 // printf("zang %f\n", zang);
 // printf("z vec = %f %f %f\n", z[0], z[1], z[2]);
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
  M(1, 0) = y[0];
  M(1, 1) = y[1];
  M(1, 2) = y[2];
  M(2, 0) = z[0];
  M(2, 1) = z[1];
  M(2, 2) = z[2];
  M(3, 0) = 0.0;
  M(3, 1) = 0.0;
  M(3, 2) = 0.0;

  M(0, 3) = 0.0;
  M(1, 3) = 0.0;
  M(2, 3) = 0.0;

  
//    M(0,3) = -eyex;
//    M(1,3) = -eyey;
//    M(2,3) = -eyez;

  M(3, 3) = 1.0;
#undef M
  
  /*
  mat4 transformedMatrix = mat4::Identity();

 // transformedMatrix = mat4::Translate(transformedMatrix, -vec3(0.5, 0.5, 0.0));
  
transformedMatrix *= mat4(m);
 // transformedMatrix = mat4::Translate(transformedMatrix, vec3(0.5, 0.5, 0.0));
  
  transformedMatrix = mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));
  //transformedMatrix = mat4::Translate(transformedMatrix, vec3(0.5, 0.5, 0.0));

  // printf("2..... here...\n");
 // mat4 transformedMatrix = mat4::Identity();
  
//  transformedMatrix = mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));
  
 // transformedMatrix = mat4::Translate(transformedMatrix, vec3(0.5, 0.5, 0.0));
//  transformedMatrix *= mat4(m);
  //transformedMatrix = mat4::Translate(transformedMatrix, -vec3(0.5, 0.5, 0.0));
  
 // transformedMatrix = mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));
  */
  
  /*
  //THIS seems to work for the Panoramic Video...
  mat4 transformedMatrix = mat4::Identity();
  //transformedMatrix *= mat4(m);
  transformedMatrix = mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));

  transformedMatrix = mat4::Translate(transformedMatrix, vec3(0.5, 0.5, 0.5));
  transformedMatrix = mat4::Scale(transformedMatrix, vec3(sx,sy,sz));
  transformedMatrix = mat4::Translate(transformedMatrix, -vec3(0.5, 0.5, 0.5));
  //END Panoramic Video
  */
  
  /*
  //works for panaromic (where there is no rotation
  mat4 transformedMatrix = mat4::Identity();
  mat4 rm = mat4(m);
  //rm = rm.Transposed();
  
//  transformedMatrix = mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));
  
  transformedMatrix = mat4::Translate(transformedMatrix, -vec3(0.5, 0.0, 0.0));
 

  transformedMatrix *= rm;
  transformedMatrix = mat4::Translate(transformedMatrix, vec3(0.5, 0.0, 0.0));
  
//  transformedMatrix = mat4::Translate(transformedMatrix, vec3(0.5, 0.5, 0.5));
//  transformedMatrix = mat4::Scale(transformedMatrix, vec3(sx,sy,sz));
//  transformedMatrix = mat4::Translate(transformedMatrix, -vec3(0.5, 0.5, 0.5));
  
  //transformedMatrix.Print();
  
  vec3 transVec = vec3(-eyex, -eyey, -eyez);
  printf("trans eye vec ");
  transVec.Print();
  */
  
  
  //REAL ONE .
  mat4 transformedMatrix = mat4(m);
  
  transformedMatrix = mat4::Translate(transformedMatrix, vec3(-eyex, -eyey, -eyez));
 
  transformedMatrix = mat4::Translate(transformedMatrix, vec3(0.5, 0.5, 0.5));
  transformedMatrix = mat4::Scale(transformedMatrix, vec3(sx,sy,sz));
  transformedMatrix = mat4::Translate(transformedMatrix, -vec3(0.5, 0.5, 0.5));

  return transformedMatrix;
  
}

void TextureCamera::moveCamX(float dist) {
  posVec += (vec3(rightVec) * dist);
  //posVec += (vec3(1,0,0) * dist);
  SetIsTransformed(true);
}

void TextureCamera::moveCamY(float dist) {
  posVec += (vec3(upVec) * dist);
  //posVec += (vec3(0,1,0) * dist);
  SetIsTransformed(true);
}

void TextureCamera::moveCamZ(float dist) {
  //posVec += vec3(0,0,-1) * dist;
  posVec += (vec3(viewVec) * dist);
  SetIsTransformed(true);
}

void TextureCamera::moveCam(vec3 dist) {
  moveCamX(dist.x);
  moveCamY(dist.y);
  moveCamZ(dist.z);
  //printf("posVec = ...");
  //posVec.Print();
}

void TextureCamera::Reset() {
  
  posVec = vec3(0.0, 0.0, 0.0);
  viewVec = vec3(0.0, 0.0f, -1.0);
  rightVec = vec3(1.0, 0.0, 0.0);
  upVec = vec3(0.0, 1.0, 0.0);  
  SetGyroscopeMatrix(mat4()); //reset rotation matrix to identity

  modelview = mat4::Identity();
  
  SetIsTransformed(true); 
}

void TextureCamera::Transform() {
 // printf("in TextureCamera::Transform()\n");
  
  if (IsTransformed()) {
    
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
   mv = mat4::RotateX(mv, GetRotate().x);
   mv = mat4::RotateY(mv, GetRotate().y);
   mv = mat4::RotateZ(mv, GetRotate().z);
   
   mv = mat4::Translate(mv, GetTranslate());
   
   SetModelView(mv);
   SetIsTransformed(false);
   */
  
  RenderCam();
  //RenderCam2();
  } else {
   // printf("doesn't need to be transformed...\n");
  }
}

void TextureCamera::RenderCam() {
 // printf("in TextureCamera::RenderCam()\n");
  //real one for incremental rotates... 
  
  
  //viewpoint is the point at which the camera looks:
  vec3 viewpoint = vec3(posVec) + viewVec;
  
  mat4 transformedMatrix = LookAt (
   posVec.x, posVec.y, posVec.z,
   viewpoint.x, viewpoint.y, viewpoint.z,
   upVec.x, upVec.y, upVec.z,
   scale.x, scale.y, scale.z                                
   );
  SetModelView(transformedMatrix);
//  printf("in Camera::RenderCam()\n");
//  modelview.Print();
  SetIsTransformed(false);
  
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

void TextureCamera::SetGyroscopeMatrix(mat4 gm) {
  //SetIsTransformed(true);
  //gyroscopeMatrix = gm;
}

mat4 TextureCamera::GetGyroscopeMatrix() {
  return gyroscopeMatrix;
}


