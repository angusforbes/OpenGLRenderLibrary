
#include "Program.hpp"


Program::Program() {
}

Program::Program(string _name)  {
  programName = _name;
  programID = -1;
  vertID = -1;
  fragID = -1;    
  
  InstallProgram();
}


//pass in the name of a shader program, like "MyShader". assumes there is a file in your bundle
//named "MyShader.vsh" and one named "MyShader.fsh".
bool Program::InstallProgram() {
  
  //cout << ApplicationEngine::NUM;
  
  programID = glCreateProgram();
  
  cout << "installing " << programName << " into ID " << programID << "\n";
  
  string vsh = "vsh";
  string vertShaderPathname = ResourceHandler::GetResourceHandler()->GetPathForResourceOfType(programName, vsh);
  
  cout << "vertex shader located at: " << vertShaderPathname << "\n";
  if (!compileShader(&vertID, GL_VERTEX_SHADER, vertShaderPathname)) {
    return false;
  }
   
  string fsh = "fsh";
  string fragShaderPathname = ResourceHandler::GetResourceHandler()->GetPathForResourceOfType(programName, fsh);
  
  if (!compileShader(&fragID, GL_FRAGMENT_SHADER, fragShaderPathname)) {
    return false;
  }
  
  
  // Attach vertex shader to program.
  //NSLog(@"attaching '%@.vsh' to '%@'\n", name, programName);
  glAttachShader(programID, vertID);
  
  // Attach fragment shader to program.
  //NSLog(@"attaching '%@.fsh' to '%@'\n", name, programName);
  glAttachShader(programID, fragID);
  
  if (!linkProgram(programID)) {
    return false; 
  }
    
  MapAttributes();
  MapUniforms();
  
  // map uniform and attribute locations.
  //[self mapAttributes];
  //[self mapUniforms];
  
  
  // Release vertex and fragment shaders.
  if (vertID) {
    glDeleteShader(vertID);
  }
  if (fragID) {
    glDeleteShader(fragID);
  }
  
  return true;
  
}



bool Program::linkProgram(GLuint prog) {
  GLint status;
  
  glLinkProgram(prog);
  
  GLint logLength;
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0)
  {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    cout << "Program link log:\n" << log;
    free(log);
  }

  
  glGetProgramiv(prog, GL_LINK_STATUS, &status);
  if (status == 0) {
    cout << "Failed to link program " << programID;
    
    if (vertID) {
      glDeleteShader(vertID);
      vertID = 0;
    }
    if (fragID) {
      glDeleteShader(fragID);
      fragID = 0;
    }
    if (programID) {
      glDeleteProgram(programID);
      programID = 0;
    }
    
    return false;
  }
  
  return true;
}


bool Program::compileShader(GLuint* shader, GLenum type, string file) {
  //NSLog(@"compiling shader '%@'", file);
  
  GLint status;
  const GLchar *source;
  
  source = (GLchar *) (ResourceHandler::GetResourceHandler()->GetContentsOfFileAsString(file));
  //source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
  if (!source)
  {
    cout << "Failed to load the shader at " << file;
    return false;
  }
  
  *shader = glCreateShader(type);
  glShaderSource(*shader, 1, &source, NULL);
  glCompileShader(*shader);
  
  GLint logLength;
  glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0)
  {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetShaderInfoLog(*shader, logLength, &logLength, log);
    cout << "Shader compile log:\n" << log;
    free(log);
  }
  
  glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
  if (status == 0)
  {
    glDeleteShader(*shader);
    cout << "Failed to create the shader named %@" << file;
    return false;
  }
  
  return true;
}



void Program::Bind() {
  //printf("about to bind %d\n", programID);
  glUseProgram(programID);
}

void Program::Unbind() {
  glUseProgram(0);
}



GLuint Program::Uniform(string name) {
  return uniforms[name];
}

GLuint Program::Attribute(string name) {
  return attributes[name];
}

void Program::MapUniforms() {
  
  GLsizei length[1];
  GLint size[1];
  GLenum type[1];
  char name[256];
  GLint count[1];
  
  glGetProgramiv(programID, GL_ACTIVE_UNIFORMS, count);
  
  for (int i = 0; i < count[0]; i++) {
    glGetActiveUniform(programID, i, 100, length, size, type, name);
    uniforms.insert(std::pair<string, GLuint>(name, glGetUniformLocation(programID, name)));
  }
}


void Program::MapAttributes() {
  
  GLsizei length[1];
  GLint size[1];
  GLenum type[1];
  char name[256];
  GLint count[1];
  
  glGetProgramiv(programID, GL_ACTIVE_ATTRIBUTES, count);
  
  for (int i = 0; i < count[0]; i++) {
    glGetActiveAttrib(programID, i, 100, length, size, type, name);
    attributes.insert(std::pair<string, GLuint>(name, glGetAttribLocation(programID, name)));
  }
}

/*

- (BOOL)linkProgram:(GLuint)prog
{
  GLint status;
  
  glLinkProgram(prog);
  
#if defined(DEBUG)
  GLint logLength;
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0)
  {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program link log:\n%s", log);
    free(log);
  }
#endif
  
  glGetProgramiv(prog, GL_LINK_STATUS, &status);
  if (status == 0) {
    NSLog(@"Failed to link program: %d", programID);
    
    
    if (vertID) {
      glDeleteShader(vertID);
      vertID = 0;
    }
    if (fragID) {
      glDeleteShader(fragID);
      fragID = 0;
    }
    if (programID) {
      glDeleteProgram(programID);
      programID = 0;
    }
    
    return FALSE;
  }
  
  return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
  GLint logLength, status;
  
  glValidateProgram(prog);
  glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
  if (logLength > 0)
  {
    GLchar *log = (GLchar *)malloc(logLength);
    glGetProgramInfoLog(prog, logLength, &logLength, log);
    NSLog(@"Program validate log:\n%s", log);
    free(log);
  }
  
  glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
  if (status == 0)
    return FALSE;
  
  return TRUE;
}



@end
*/
