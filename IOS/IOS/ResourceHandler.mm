
#import "ResourceHandler.h"
#import "AudioManager.h"
#import "VideoManager.h"

#ifdef IS_IOS
#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
//#import <OpenGLES/ES2/gl.h>
//#import <OpenGLES/ES2/glext.h>
#import <CoreFoundation/CoreFoundation.h>
#import "AppDelegate.h"
#include "IOSGLView.h"
#endif


#ifdef IS_COCOA
#import "AppDelegate.h"
#import "NSGLView.h"
//#include <OpenGL/gl.h>
//#include <OpenGL/glext.h>
#endif

using namespace std;

AudioManager *audioManager;
VideoManager *videoManager;
/*
AVAssetReader* assetReader;
AVAssetReaderTrackOutput* videoTrackOutput = NULL;
//AVAssetReaderTrackOutput* audioTrackOutput = NULL;
AVAsset *currentAsset;
CMSampleBufferRef pixelBuffer;
*/



ResourceHandler* ResourceHandler::instance = NULL;

ResourceHandler* ResourceHandler::CreateResourceHandler() {
  instance = new ResourceHandler();
  return instance; 
}

ResourceHandler* ResourceHandler::GetResourceHandler() {
  if (ResourceHandler::instance == NULL) {
    CreateResourceHandler();
  }
  return instance;
}

ResourceHandler::ResourceHandler() { 
}


bool ResourceHandler::IsUsingGyro() {
  
 // IOSGLView* v = (IOSGLView*)(( AppDelegate* )[[ UIApplication sharedApplication ] delegate ]).viewController.view;
  IOSGLView* v = (IOSGLView*) GetView();
  //return false;
  return [v isUsingGyro]; 
}

void* ResourceHandler::GetView() {
//UIView* ResourceHandler::GetView() {
 //return (( AppDelegate* )[[ UIApplication sharedApplication ] delegate ]).view;
//return (IOSGLView*)(( AppDelegate* )[[ UIApplication sharedApplication ] delegate ]).viewController.view;
  return (( AppDelegate* )[[ UIApplication sharedApplication ] delegate ]).viewController.view;
}


void ResourceHandler::ResetGyroscope() {
  //IOSGLView* view = (( AppDelegate* )[[ UIApplication sharedApplication ] delegate ]).view;
  IOSGLView* view = (IOSGLView*)(( AppDelegate* )[[ UIApplication sharedApplication ] delegate ]).viewController.view;
  view.referenceAttitude = [view.motionManager.deviceMotion.attitude retain];
}


string ResourceHandler::GetResourcePath() const {
  NSString* bundlePath =[[NSBundle mainBundle] resourcePath];
  return [bundlePath UTF8String];
  
   
}

const char* ResourceHandler::GetContentsOfFileAsString(string& file) {
  NSString* filePath = [[NSString alloc] initWithUTF8String:file.c_str()];
  NSString* contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
  return [contents UTF8String];
}

string ResourceHandler::GetPathForResourceOfType(const string& resource, const string& type) {
  
  NSString* resourcePath = [[NSString alloc] initWithUTF8String:resource.c_str()];
  NSString* typePath = [[NSString alloc] initWithUTF8String:type.c_str()];
  
  NSBundle* mainBundle = [NSBundle mainBundle];
  NSString* fullPath = [mainBundle pathForResource:resourcePath ofType:typePath];
  
  return [fullPath UTF8String];
}


Texture* ResourceHandler::CreateCubeMapTextureFromImageFile(const string &fname) {
  
  GLubyte** cubeData = (GLubyte**)malloc( sizeof(GLubyte*) * 6 );
  //GLvoid** cubeData = (GLvoid**)malloc( sizeof(GLvoid*) * 6 );
  
  NSString* basePath = [[NSString alloc] initWithUTF8String:fname.c_str()];
  NSArray* splits = [basePath componentsSeparatedByString: @"."];
  
  NSString* fileStr = [splits objectAtIndex:0];
  NSString* typeStr = [splits objectAtIndex:1];
  
  int cw;
  int ch;
  
  
  
  for (int i = 0; i < 6; i++) {
    
    //loading in files like "myCubeMap_0.jpg", etc
    NSString* useFileStr = [NSString stringWithFormat:@"%@_%d", fileStr, i];
    NSString* path = [[NSBundle mainBundle] pathForResource:useFileStr ofType:typeStr];
    NSLog(@"Loading texture: %@.%@\n", useFileStr, typeStr);
    
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    
    if (image == nil) {
      NSLog(@"in ResourceHandler::CreateCubeMapTextureFromImageFile, image %@ is NULL!", useFileStr);
    }
    
    //these better be the same for all six images!
    int _w = CGImageGetWidth(image.CGImage);
    int _h = CGImageGetHeight(image.CGImage);
    
    if (i == 0) {
      cw = _w;
      ch = _h;
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    GLubyte* data = (GLubyte*)malloc( _w * _h * 4 );
    //GLvoid* data = (GLvoid*)malloc( _w * _h * 4 );
    
    CGContextRef context = CGBitmapContextCreate( data, _w, _h, 8, 4 * _w, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, _w, _h ) );
    //CGContextTranslateCTM( context, 0, height - height );
    
    CGContextTranslateCTM(context, 0, _h);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextDrawImage( context, CGRectMake( 0, 0, _w, _h ), image.CGImage );
    
    CGContextRelease(context);
    
    [texData release];
    
    cubeData[i] = data;
//    cubeData[0] = data;
//    cubeData[1] = data;
//    cubeData[2] = data;
//    cubeData[3] = data;
//    cubeData[4] = data;
//    cubeData[5] = data;
    
    
  }
  
  return new Texture(cubeData, cw, ch, GL_RGBA, GL_UNSIGNED_BYTE);
}


void ResourceHandler::NextVideoFrame() {
  if (videoManager != NULL) {
    [videoManager nextVideoFrame];
  }
}

Texture* ResourceHandler::CreateVideoTexture(const string &fname) {
  return CreateVideoTexture(fname, false, true, true); 
}

void* ResourceHandler::RetrieveAsset(const string &fname) {
  
  NSString* basePath = [[NSString alloc] initWithUTF8String:fname.c_str()];
  NSArray* splits = [basePath componentsSeparatedByString: @"."];
  
  NSString* fileStr = [splits objectAtIndex:0];
  NSString* typeStr = [splits objectAtIndex:1];
  
  NSLog(@"Loading asset at: %@.%@\n", fileStr, typeStr);
  NSString* path = [[NSBundle mainBundle] pathForResource:fileStr ofType:typeStr];
  
  if (path == NULL) {
    printf("Could not find video file inside of bundle...\n");
    return NULL;
  }
  
  NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
  return [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:options];
}

Texture* ResourceHandler::CreateVideoTexture(const string &fname, bool useAudio, bool autoPlay, bool autoLoop ) {
  AVAsset* currentAsset = (AVAsset*)RetrieveAsset(fname);
  NSDate *date = [NSDate dateWithTimeIntervalSinceNow: 3.0];
  double atTime = [date timeIntervalSinceReferenceDate];
  
  //SET UP AUDIO TRACK
  if (useAudio) {
    PlayAudioResource(fname, atTime);
  }
  
  //SET UP VIDEO TRACK
  videoManager = [[VideoManager alloc] init];
  [videoManager retain];
  Texture* videoTexture = [videoManager setUpVideoThread:currentAsset isLooping:autoLoop];
  
  if (autoPlay) {
    [videoManager startVideoThread:atTime];
  }
  return videoTexture;
}

void ResourceHandler::PlayAudioResource(const string &fname) {
  NSDate *atTime = [NSDate dateWithTimeIntervalSinceNow: 3.0];
  double threeSec = [atTime timeIntervalSinceReferenceDate];
  PlayAudioResource(fname, threeSec);
}

void ResourceHandler::PlayAudioResource(const string &fname, double atTime) {
  
  AVAsset* currentAsset = (AVAsset*)RetrieveAsset(fname);
  
  if ([[currentAsset tracksWithMediaType:AVMediaTypeAudio] count] > 0) {
    audioManager = [[AudioManager alloc] init];
    [audioManager retain]; 
    [audioManager resetData];
    [audioManager setUpAudioThread:currentAsset];
    [audioManager startAudioThread:atTime]; 
  }
}

/*
 void ResourceHandler::LoadPngImage(const string& name)
 {
 NSString* basePath = [[NSString alloc] initWithUTF8String:name.c_str()];
 NSBundle* mainBundle = [NSBundle mainBundle];
 NSString* fullPath = [mainBundle pathForResource:basePath ofType:@"png"];
 UIImage* uiImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
 CGImageRef cgImage = uiImage.CGImage;
 m_imageSize.x = CGImageGetWidth(cgImage);
 m_imageSize.y = CGImageGetHeight(cgImage);
 m_imageData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
 [uiImage release];
 [basePath release];
 }
 
 void* ResourceHandler::GetImageData()
 {
 return (void*) CFDataGetBytePtr(m_imageData);
 }
 
 ivec2 ResourceHandler::GetImageSize()
 {
 return m_imageSize;
 }
 
 void ResourceHandler::UnloadImage()
 {
 CFRelease(m_imageData);
 }
 
 
 //    CFDataRef m_imageData;
 //    ivec2 m_imageSize;
 */


Texture* ResourceHandler::CreateTextureFromImageFile(const string &fname) {
  
  NSString* basePath = [[NSString alloc] initWithUTF8String:fname.c_str()];
  NSArray* splits = [basePath componentsSeparatedByString: @"."];
  
  NSString* fileStr = [splits objectAtIndex:0];
  NSString* typeStr = [splits objectAtIndex:1];
  
  NSString* path = [[NSBundle mainBundle] pathForResource:fileStr ofType:typeStr];
  NSLog(@"Loading texture: %@.%@\n", fileStr, typeStr);
  
  NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
  UIImage *image = [[UIImage alloc] initWithData:texData];
  
  if (image == nil) {
    NSLog(@"Umm... ERROR!!!! image is NULL!!!!");
  }
  
  int _w = CGImageGetWidth(image.CGImage);
  int _h = CGImageGetHeight(image.CGImage);
  
  /* //test to make POT
   
   int useW = 2048;
   int useH = 2048;
   int marginW = (_w - useW)/2;
   int marginH = (_h - useH)/2;
   _w = useW;
   _h = useH;
   */
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  GLubyte* data = (GLubyte*)malloc( _w * _h * 4 );
  
  CGContextRef context = CGBitmapContextCreate( data, _w, _h, 8, 4 * _w, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
  CGColorSpaceRelease( colorSpace );
  CGContextClearRect( context, CGRectMake( 0, 0, _w, _h ) );
  //CGContextTranslateCTM( context, 0, height - height );
  
  //  CGContextTranslateCTM(context, _w, 0);
  //  CGContextScaleCTM(context, -1, 1);
  
  
  
  CGContextDrawImage( context, CGRectMake( 0, 0, _w, _h ), image.CGImage );
  //CGContextDrawImage( context, CGRectMake( marginW, marginH, useW, useH ), image.CGImage );
  
  
  CGContextRelease(context);
  
  [texData release];
  
  return new Texture(data, _w, _h, GL_RGBA, GL_UNSIGNED_BYTE);
  //return new Texture(data, useW, useH, GL_RGBA, GL_UNSIGNED_BYTE);
}



Texture* ResourceHandler::LoadDunitesTexture(const string &fname) {
  
  int _w = 123;
  int _h = 200;
  int _d = 60;
  
  int cols = 10;
  int rows = 6;
  //let's try 10x6
  int dw = _w * cols;
  int dh = _h * rows;
  
  Texture* duniteTex = new Texture(dw, dh, GL_RGBA, GL_UNSIGNED_BYTE);
  
  NSString* basePath = [[NSString alloc] initWithUTF8String:fname.c_str()];
  NSArray* splits = [basePath componentsSeparatedByString: @"."];
  
  NSString* fileStr = [splits objectAtIndex:0];
  NSString* typeStr = [splits objectAtIndex:1];
  
  //GLubyte* alldata = (GLubyte*)malloc( (_w * _h * 4) * _d );
  
  int i = 1;
  
  for (int y = 0; y < rows; y++) {
    
  for (int x = 0; x < cols; x++) {
      
    NSString* useFileStr = [NSString stringWithFormat:@"%@%02d", fileStr, i];
    NSString* path = [[NSBundle mainBundle] pathForResource:useFileStr ofType:typeStr];
    NSLog(@"Loading texture: %@.%@\n", useFileStr, typeStr);
    
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    UIImage *image = [[UIImage alloc] initWithData:texData];
    
    int _w = CGImageGetWidth(image.CGImage);
    int _h = CGImageGetHeight(image.CGImage);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    GLubyte* data = (GLubyte*)malloc( _w * _h * 4 );
    
    CGContextRef context = CGBitmapContextCreate( data, _w, _h, 8, 4 * _w, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
    CGColorSpaceRelease( colorSpace );
    CGContextClearRect( context, CGRectMake( 0, 0, _w, _h ) );
    
    CGContextDrawImage( context, CGRectMake( 0, 0, _w, _h ), image.CGImage );
    //CGContextDrawImage( context, CGRectMake( marginW, marginH, useW, useH ), image.CGImage );    
    CGContextRelease(context);
    [texData release];
    
      //write this data into the big texture
      duniteTex->Bind();
      glTexSubImage2D(GL_TEXTURE_2D, 0, x * _w, y * _h, _w, _h, GL_RGBA, GL_UNSIGNED_BYTE, data);
      duniteTex->Unbind();
      
      i++;
    }
  }
  
  return duniteTex;
 // return new Texture(alldata, _w, _h, _d, GL_RGBA, GL_UNSIGNED_BYTE); 
  
}


