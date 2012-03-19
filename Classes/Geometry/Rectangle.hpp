
#include "Vector.hpp"
#include "Matrix.hpp"
#include "Geom.hpp"
#include <vector>

#ifndef RECTANGLE_H
#define RECTANGLE_H


class Rectangle : public Geom { 
  
public:
  Rectangle();
  Rectangle(vec3 translate, float width, float height);
  
  //from ModelView
  virtual void Transform();
  
  //from Mesh
  virtual void GenerateLineIndices();
  virtual void GenerateTriangleIndices();
  virtual int GetVertexCount() ;
  virtual int GetLineIndexCount() ;
  virtual int GetTriangleIndexCount() ;
  
  string String();
  //float width;
  //float height;

  
private:

    void GenerateVertices() ;
  
};



#endif
