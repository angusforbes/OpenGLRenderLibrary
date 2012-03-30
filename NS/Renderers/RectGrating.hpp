

#include "Vector.hpp"
#include "Matrix.hpp"
#include "Rectangle.hpp"
#include <vector>

#ifndef OpenGLRenderLibraryNS_RectGrating_hpp
#define OpenGLRenderLibraryNS_RectGrating_hpp








class RectGrating : public Rectangle { 
  
public:
  
  RectGrating(int _kind, Texture* _mask, vec4 _color, vec4 _backgroundColor, 
              float _freq, float _phase, float _theta, float _phaseSpeed);
  RectGrating(int _kind, Texture* _mask, vec4 _color, vec4 _backgroundColor, 
              float _freq, float _phase, float _theta, float _phaseSpeed,
              int _step, float _thickness);

  //RectGrating();
  //RectGrating(vec3 translate, float width, float height);
  
  int kind;
  Texture* mask;
  vec4 color;
  vec4 backgroundColor;
  float freq;
  float phase;
  float theta;
  
  float phaseSpeed;
  
  int step;
  float thickness;
  
  bool choose;
  bool isSelected;
};

#endif
