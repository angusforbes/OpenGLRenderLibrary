#include <iostream>
#include <map>
#include "ResourceHandler.h"

#ifndef PROGRAM
#define PROGRAM


using namespace std;

class Program {
  
public:
 
  Program();
  Program(string _name);
  GLuint programID;
  GLuint vertID;
  GLuint fragID;
  string programName;
  void Bind();
  void Unbind();
  GLuint Uniform(string name);
  GLuint Attribute(string name);
  
  
private:
  bool InstallProgram();
  bool compileShader(GLuint* shader, GLenum type, string file);
  bool linkProgram(GLuint prog);
  void MapAttributes();
  void MapUniforms();
  map<string, GLuint> uniforms;
  map<string, GLuint> attributes;
};
#endif