
#include "GratingFunctions.hpp"
#include "Utils.hpp"

vec4 GratingFunctions::ChooseColor() {
  
  
  vec4 color;
  int which = Utils::randomIntBetween(0,19);
  
  switch (which) {
    case 0:
      color = vec4( 183, 148, 114 ,255); break;
    case 1:
      color = vec4(  242, 148, 80, 255); break;
    case 2:
      color = vec4(   240, 204, 88,255); break;
    case 3:
      color = vec4(  253, 100, 93,255); break;
    case 4:
      color = vec4(  255, 154, 121,255); break;
    case 5:
      color = vec4(  149, 151, 49,255); break;
    case 6:
      color = vec4( 156, 199, 36,255); break;
    case 7:
      color = vec4(  110, 154, 66,255); break;
    case 8:
      color = vec4( 56, 211, 78,255); break;
    case 9:
      color = vec4(    84, 222, 176,255); break;
    case 10:
      color = vec4( 53, 192, 192,255); break;
    case 11:
      color = vec4( 108, 181, 209,255); break;
    case 12:
      color = vec4(   117, 191, 255, 255); break;
    case 13:
      color = vec4( 124, 121, 226,255); break;
    case 14:
      color = vec4( 181, 178, 255,255); break;
    case 15:
      color = vec4(  139, 94, 223,255); break;
    case 16:
      color = vec4(   178, 135, 201,255); break;
    case 17:
      color = vec4(  237, 104, 237,255); break;
    case 18:
      color = vec4( 241, 160, 201,255); break;
    case 19:
      color = vec4(    29, 45, 250 ,255); break;
    default:
      color = vec4( 255,255,255, 255); break;
      
  }
  /*
   switch (which) {
   case 0:
   color = vec4(217, 177, 137, 255); break;
   case 1:
   color = vec4(242, 162, 175, 255); break;
   case 2:
   color = vec4(225, 113, 117, 255); break;
   case 3:
   color = vec4(225, 128, 107, 255); break;
   case 4:
   color = vec4(169, 163, 19, 255); break;
   case 5:
   color = vec4(147, 176, 32, 255); break;
   case 6:
   color = vec4(118, 181, 39, 255); break;
   case 7:
   color = vec4(49, 186, 60, 255); break;
   case 8:
   color = vec4(44, 184, 128, 255); break;
   case 9:
   color = vec4(37, 182, 71, 255); break;
   case 10:
   color = vec4(79, 184, 213, 255); break;
   case 11:
   color = vec4( 103, 177, 225 , 255); break;
   case 12:
   color = vec4(137, 168, 225  , 255); break;
   case 13:
   color = vec4( 155, 159, 225  , 255); break;
   case 14:
   color = vec4( 171, 152, 222 , 255); break;
   case 15:
   color = vec4(  188, 146, 217 , 255); break;
   case 16:
   color = vec4(  206, 139, 210 , 255); break;
   case 17:
   color = vec4( 213, 141, 182 , 255); break;
   case 18:
   color = vec4( 214, 143, 159 , 255); break;
   case 19:
   color = vec4( 191, 151, 151 , 255); break;
   default:
   color = vec4( 255,255,255, 255); break;
   
   }
   */
  
  return color / 255.0;
}

void GratingFunctions::DrawGrating(FBO* fbo, Program* program, RectGrating* geom) {
  
  
  if (fbo != NULL) {
    fbo->Bind();
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
  }
  
  program->Bind(); {
    glUniformMatrix4fv(program->Uniform("Modelview"), 1, 0, geom->GetModelView().Pointer());
    glUniformMatrix4fv(program->Uniform("Projection"), 1, 0, mat4::Identity().Pointer());
    
    glUniform4fv(program->Uniform("ContrastColor"), 1, geom->backgroundColor.Pointer());
    glUniform4fv(program->Uniform("BaseColor"), 1, geom->color.Pointer());
    glUniform1f(program->Uniform("FreqVal"), geom->freq * (M_PI*2.0));
    glUniform1f(program->Uniform("PhaseVal"), geom->phase);
    glUniform1f(program->Uniform("ThetaVal"), radians(geom->theta));
    glUniform1i(program->Uniform("Step"), geom->step);
    glUniform1f(program->Uniform("Thickness"),geom->thickness);
    
    
    if (geom->kind == 99) {
      glUniform1i(program->Uniform("Pulse"), 1);
    } else {
      glUniform1i(program->Uniform("Pulse"), 0);
    }
    
    //glUniform1i(program->Uniform("Pulse"), 0);
    
    geom->mask->Bind(GL_TEXTURE0); 
    glUniform1i(program->Uniform("Mask"), 0);
    
    geom->PassVertices(program, GL_TRIANGLES);
    geom->mask->Unbind(GL_TEXTURE0); 
    
  } program->Unbind();
  
  if (fbo != NULL) {
    
    fbo->Unbind();
  } 
}

