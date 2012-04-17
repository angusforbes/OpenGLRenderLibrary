
#include "Texture.hpp"
#include "FontAtlas.hpp"
//#include <CoreMotion/CoreMotion.h>
#include <iostream> 

#ifndef RESOURCE_HANDLER_H
#define RESOURCE_HANDLER_H


using namespace std;

class ResourceHandler {
  
public:
    
  static ResourceHandler* CreateResourceHandler();
  static ResourceHandler* GetResourceHandler();
  
  
  FontAtlas* LoadFontAtlas(const string &fname);

  string GetResourcePath() const;
  
  const char* GetContentsOfFileAsString(string& file);  
  string GetPathForResourceOfType(const string& resource, const string& type);  
  
  Texture* CreateTextureFromImageFile(const string &fname) ;  
  Texture* CreateCubeMapTextureFromImageFile(const string &fname) ;

  void* GetView();
  float GetElapsedTime();
  
  void ResetGyroscope();
//  void LoadPngImage(const string& name);
//  void* GetImageData();
//  
//  ivec2 GetImageSize();
//  void UnloadImage();
  
  Texture* LoadDunitesTexture(const string &fname);
  
  Texture* CreateVideoTexture(const string &fname);
  void HandlePlayback( Texture* videoTexture, bool isLooping);
  //void HandlePlayback(const Texture &videoTexture) const;
  
  //CMSampleBufferRef* HandlePlayback() const;
  //void ProcessPixelBuffer(CMSampleBufferRef pixelBuffer);
  void ProcessPixelBuffer() const;
private:
  ResourceHandler();
  static ResourceHandler* instance;
  
  //int MatchPattern(NSString *string, NSString* pattern);
  void Replay();
//  CFDataRef m_imageData;
//  ivec2 m_imageSize;
};

#endif

