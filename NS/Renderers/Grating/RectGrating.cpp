#include "RectGrating.hpp"


RectGrating::RectGrating(int _kind, Texture* _mask, vec4 _color, vec4 _backgroundColor, 
                         float _freq, float _phase, float _theta,
                         float _phaseSpeed) : Rectangle() {
 
  freq = _freq;
  phase = _phase;
  theta = _theta;
  color = _color; //vec4(1.0,0.5,0.5,1.0);
  backgroundColor = _backgroundColor; //vec4(0.0,0.0,0.0,1.0);
  
  phaseSpeed = _phaseSpeed;
  // ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  mask = _mask; //rh->CreateTextureFromImageFile("circle.png");
  kind = _kind;
  
  step = 0;
  thickness = 0.0; 
  
}

RectGrating::RectGrating(int _kind, Texture* _mask, vec4 _color, vec4 _backgroundColor, 
                         float _freq, float _phase, float _theta,
                         float _phaseSpeed,
                         int _step, float _thickness) : Rectangle() {
  
  freq = _freq;
  phase = _phase;
  theta = _theta;
  color = _color; //vec4(1.0,0.5,0.5,1.0);
  backgroundColor = _backgroundColor; //vec4(0.0,0.0,0.0,1.0);
 
  phaseSpeed = _phaseSpeed;
 // ResourceHandler* rh = ResourceHandler::GetResourceHandler();
  mask = _mask; //rh->CreateTextureFromImageFile("circle.png");
  kind = _kind;
  
  step = _step;
  thickness = _thickness; 
}
