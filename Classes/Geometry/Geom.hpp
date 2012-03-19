
#include "Mesh.hpp"
#include "ModelView.hpp"
#include "Vector.hpp"
#include "Matrix.hpp"

#ifndef OpenGLRenderLibraryNS_Geom_hpp
#define OpenGLRenderLibraryNS_Geom_hpp

class Geom : public ModelView, public Mesh {
  
public:
  
  Geom();
  //Geom(vec3 translate, float width, float height);
  
  /*
  //from ModelView
  virtual void Transform();
  
  //from Mesh
  virtual void GenerateLineIndices();
  virtual void GenerateTriangleIndices();
  virtual int GetVertexCount() ;
  virtual int GetLineIndexCount() ;
  virtual int GetTriangleIndexCount() ;
  */
};

#endif
