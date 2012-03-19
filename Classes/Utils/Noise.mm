
#include "Noise.hpp"
#include "Utils.hpp"

GLubyte* Noise::CreateColorNoise(int _w, int _h) {
  
  GLubyte* data = (GLubyte*) malloc (_w*_h*4*sizeof(GLubyte));
 
  for (int i = 0; i < _w * _h * 4; i+=4) {
    data[i] = Utils::randomIntBetween(0,255); 
    data[i+1] = Utils::randomIntBetween(0,255); 
    data[i+2] = Utils::randomIntBetween(0,255); 
    data[i+3] = 255; //alpha;
  }  
  return data;
}

GLubyte* Noise::CreateRgbNoise(int _w, int _h) {
  
  GLubyte* data = (GLubyte*) malloc (_w*_h*4*sizeof(GLubyte));
  int num;
  for (int i = 0; i < _w * _h * 4; i+=4) {
    
    data[i] = 0; 
    data[i+1] = 0; 
    data[i+2] = 0; 
    data[i+3] = 255; //alpha;
    
    num = Utils::randomIntBetween(0,2);
    
    if (num == 0) {
      data[i] = 255; 
    } else if (num == 1) {
      data[i+1] = 255; 
    } else {
      data[i+2] = 255; 
    }
  }
  
  return data;
  
}