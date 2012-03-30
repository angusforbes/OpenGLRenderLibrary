
#include "FBO.hpp"
#include "RectGrating.hpp"
#include "Program.hpp"

#ifndef OpenGLRenderLibraryNS_GratingFunctions_hpp
#define OpenGLRenderLibraryNS_GratingFunctions_hpp

class GratingFunctions { 

public:
  static void DrawGrating(FBO* fbo, Program* program, RectGrating* geom);
  static vec4 ChooseColor();
  static vec4 ChooseColor(int which);
  
};

#endif
