
#import "ResourceHandler.h"

//#import <Foundation/Foundation.h>
//#import <AssetsLibrary/AssetsLibrary.h>
//#import <MobileCoreServices/MobileCoreServices.h>
//#import <AVFoundation/AVFoundation.h>
//#import <OpenGLES/ES2/gl.h>
//#import <OpenGLES/ES2/glext.h>
//#import <CoreFoundation/CoreFoundation.h>

#import "AppDelegate.h"
#import "NSGLView.h"

using namespace std;

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

float ResourceHandler::GetElapsedTime() {
  NSGLView* v = (NSGLView*) GetView(); 
  return [v getTotalTime];
}

void* ResourceHandler::GetView() {
  AppDelegate* ad = (AppDelegate*) [NSApp delegate];
  return ad.glview;
  
  //return (( AppDelegate* )[[ UIApplication sharedApplication ] delegate ]).view;
  //return NULL;
}


void ResourceHandler::ResetGyroscope() {
  //  GLView* view = (( AppDelegate* )[[ UIApplication sharedApplication ] delegate ]).view;
  //  view.referenceAttitude = [view.motionManager.deviceMotion.attitude retain];
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
  
  cout << "resourcePath =  " << resource << "\n";
  
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
    NSImage *nsimage = [[NSImage alloc] initWithData:texData];
    
    if (nsimage == nil) {
      NSLog(@"in ResourceHandler::CreateCubeMapTextureFromImageFile, image %@ is NULL!", useFileStr);
    }
    
    
    NSBitmapImageRep *imageClass = [[NSBitmapImageRep alloc] initWithData:[nsimage TIFFRepresentation]];
    [nsimage release];
    
    CGImageRef cgImage = imageClass.CGImage;
    
    //these better be the same for all six images!
    int _w = CGImageGetWidth(cgImage);
    int _h = CGImageGetHeight(cgImage);
    
    
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
    
    CGContextDrawImage( context, CGRectMake( 0, 0, _w, _h ), cgImage );
    
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
  
  // return new Texture(cubeData, cw, ch);
  return new Texture(cubeData, cw, ch, GL_RGBA, GL_UNSIGNED_BYTE);
  
}


Texture* ResourceHandler::LoadDunitesTexture(const string &fname) {
  
  NSString* basePath = [[NSString alloc] initWithUTF8String:fname.c_str()];
  NSArray* splits = [basePath componentsSeparatedByString: @"."];
  
  NSString* fileStr = [splits objectAtIndex:0];
  NSString* typeStr = [splits objectAtIndex:1];
  
  int _w = 123;
  int _h = 200;
  int _d = 60;
  
  GLubyte* alldata = (GLubyte*)malloc( (_w * _h * 4) * _d );
  
  
  //int i = 1; //starts at 1
  for (int i = 1; i <= _d; i++) {
    
    //loading in files like "FILE0.jpg", etc
    NSString* useFileStr = [NSString stringWithFormat:@"%@%02d", fileStr, i];
    NSString* path = [[NSBundle mainBundle] pathForResource:useFileStr ofType:typeStr];
    NSLog(@"Loading texture: %@.%@\n", useFileStr, typeStr);
    
    NSData *texData = [[NSData alloc] initWithContentsOfFile:path];
    
    NSImage *nsimage = [[NSImage alloc] initWithData:texData];
    
    
    NSBitmapImageRep *imageClass = [[NSBitmapImageRep alloc] initWithData:[nsimage TIFFRepresentation]];
    [nsimage release];
    
    CGImageRef cgImage = imageClass.CGImage;
    
    //int _w = CGImageGetWidth(cgImage);
    //int _h = CGImageGetHeight(cgImage);
    
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //GLubyte* data = (GLubyte*)malloc( _w * _h * 4 );
    int pos = (_w * _h * 4) * (i-1);
    GLubyte* data = &alldata[pos];
    
    
    CGContextRef context = CGBitmapContextCreate(data, _w, _h, 8, _w * 4, colorSpace, kCGImageAlphaNoneSkipLast);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    /*  if(flipVertical)
     {
     CGContextTranslateCTM(context, 0.0, _h);
     CGContextScaleCTM(context, 1.0, -1.0);
     }
     */
    
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, _w, _h), cgImage);
    CGContextRelease(context);
    
    [texData release];
  }
  
  
  return new Texture(alldata, _w, _h, _d, GL_RGBA, GL_UNSIGNED_BYTE); 
  
}


int MatchPattern(NSString *string, NSString* pattern) {
  
  NSError *error;
  //NSString *pattern = @"x=[0-9+]";
  
  NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
  if ( ! regularExpression) {
    NSLog(@"Error in pattern <%@>: %@", pattern, error);
    exit(0);
  }
  
  NSRange range = NSMakeRange(0, [string length]);
  NSArray *matches = [regularExpression matchesInString:string options:0 range:range];
  if ([matches count]) {
    NSTextCheckingResult *firstMatch = [matches objectAtIndex:0];
    // NSLog(@"Found %lu submatches", (unsigned long)[firstMatch numberOfRanges]);
    for (NSUInteger i = 0; i < [firstMatch numberOfRanges]; ++i) {
      NSRange range = [firstMatch rangeAtIndex:i];
      NSString *submatch = [string substringWithRange:range];
      // NSLog(@"submatch %lu: <%@>", (unsigned long)i, submatch);   
      
      NSArray* splits = [submatch componentsSeparatedByString: @"="];
      return [[splits objectAtIndex:1] intValue];
    }
  } else {
    // NSLog(@"Pattern <%@> doesn't match string <%@>", pattern, string);
  }
  return -1;
}

NSString* MatchPatternString(NSString *string, NSString* pattern) {
  
  NSError *error;
  
  NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
  if ( ! regularExpression) {
    NSLog(@"Error in pattern <%@>: %@", pattern, error);
    exit(0);
  }
  
  NSRange range = NSMakeRange(0, [string length]);
  NSArray *matches = [regularExpression matchesInString:string options:0 range:range];
  if ([matches count]) {
    NSTextCheckingResult *firstMatch = [matches objectAtIndex:0];
    // NSLog(@"Found %lu submatches", (unsigned long)[firstMatch numberOfRanges]);
    for (NSUInteger i = 0; i < [firstMatch numberOfRanges]; ++i) {
      NSRange range = [firstMatch rangeAtIndex:i];
      NSString *submatch = [string substringWithRange:range];
      // NSLog(@"submatch %lu: <%@>", (unsigned long)i, submatch);   
      
      NSArray* splits = [submatch componentsSeparatedByString: @"=\""];
      return [splits objectAtIndex:1];
    }
  } else {
    // NSLog(@"Pattern <%@> doesn't match string <%@>", pattern, string);
  }
  return @"UNKNOWN";
}


//requires there to be a (.png) texture atlas and its associated AngelFont (.fnt) file 
FontAtlas* ResourceHandler::LoadFontAtlas(const string &fname) {
  
  NSString* face;
  int sizeVal;
  bool isBold;
  bool isItalic;
  int lineHeightVal;
  int baseVal;
  int twVal;
  int thVal;
  map<char, FontData*> values;
  
  cout << "fontName = " <<fname <<"\n"; 
  Texture* fontTexture = CreateTextureFromImageFile(fname + ".png");
  
  NSString* basePath = [[NSString alloc] initWithUTF8String:fname.c_str()];
  NSString* path = [[NSBundle mainBundle] pathForResource:basePath ofType:@"fnt"];
  //NSLog(@"path: %@\n", path);
  
  NSString *contents = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
  NSArray *lines = [contents componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\r\n"]];
  for (NSString* line in lines) {
    if (line.length) {
      //NSLog(@"line: %@", line);
      
      if([line hasPrefix:@"info"]) {
        //printf("info line...\n");
        
        face = MatchPatternString(line, @"face=\"[0-9a-zA-Z]+");
        sizeVal = MatchPattern(line, @"size=[0-9]+");
        isBold = MatchPattern(line, @"bold=[0-9]+");
        isItalic = MatchPattern(line, @"italic=[0-9]+");
        //NSLog(@"info: face=%@, size=%d, isBold=%d, isItalic=%d\n", face, sizeVal, isBold, isItalic); 
      } else if ([line hasPrefix:@"common"]) {
        lineHeightVal = MatchPattern(line, @"lineHeight=[0-9]+");
        baseVal = MatchPattern(line, @"base=[0-9]+");
        twVal = MatchPattern(line, @"scaleW=[0-9]+");
        thVal = MatchPattern(line, @"scaleH=[0-9]+");
        //printf("found line lineHeight:%d, base:%d, scaleW:%d scaleH:%d\n", lineHeightVal, baseVal, twVal, thVal);
      } else if ([line hasPrefix:@"char id"]) {
        int idVal = MatchPattern(line, @"id=[0-9]+");
        int xVal = MatchPattern(line, @"x=[0-9]+");
        int yVal = MatchPattern(line, @"y=[0-9]+");
        int wVal = MatchPattern(line, @"width=[0-9]+");
        int hVal = MatchPattern(line, @"height=[0-9]+");
        int xOffsetVal = MatchPattern(line, @"xoffset=[0-9]+");
        int yOffsetVal = MatchPattern(line, @"yoffset=[0-9]+");
        int xAdvance = MatchPattern(line, @"xadvance=[0-9]+");
        
        //printf("found x (%c) ,y,id : %d, %d, %d\n", idVal, xVal, yVal, idVal);
        values.insert(std::pair<char, FontData*>(idVal, new FontData((char)idVal, xVal, yVal, wVal, hVal, xOffsetVal, yOffsetVal, xAdvance)));
        
      } else {
        //printf("HUH???");
      }
    }
  }
  
  return new FontAtlas(fontTexture, twVal, thVal, 
                                   [face UTF8String], isBold, isItalic, 
                                   lineHeightVal, baseVal,
                                   values );
    
}


//- (id) initTextureFromFilename:(NSString*) filename {
Texture* ResourceHandler::CreateTextureFromImageFile(const string &fname) {
  
  NSString* basePath = [[NSString alloc] initWithUTF8String:fname.c_str()];
  NSArray* splits = [basePath componentsSeparatedByString: @"."];
  
  NSString* fileStr = [splits objectAtIndex:0];
  NSString* typeStr = [splits objectAtIndex:1];
  
  NSString* pathname = [[NSBundle mainBundle] pathForResource:fileStr ofType:typeStr];
  NSLog(@"Loading texture: %@.%@\n", fileStr, typeStr);
  
  NSLog(@"loading in texture from path: %@\n", pathname);
  NSData *texData = [[NSData alloc] initWithContentsOfFile:pathname];
  NSImage *nsimage = [[NSImage alloc] initWithData:texData];
  
  
  NSBitmapImageRep *imageClass = [[NSBitmapImageRep alloc] initWithData:[nsimage TIFFRepresentation]];
	[nsimage release];
  
  CGImageRef cgImage = imageClass.CGImage;
  
  int _w = CGImageGetWidth(cgImage);
  int _h = CGImageGetHeight(cgImage);
  
  
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  GLubyte* data = (GLubyte*)malloc( _w * _h * 4 );
  
  CGContextRef context = CGBitmapContextCreate(data, _w, _h, 8, _w * 4, colorSpace, kCGImageAlphaNoneSkipLast);
	CGContextSetBlendMode(context, kCGBlendModeCopy);
	
  /*  if(flipVertical)
   {
   CGContextTranslateCTM(context, 0.0, _h);
   CGContextScaleCTM(context, 1.0, -1.0);
   }
   */
  
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, _w, _h), cgImage);
	CGContextRelease(context);
	
  [texData release];
  
  return new Texture(data, _w, _h, GL_RGBA, GL_UNSIGNED_BYTE);
  
}

/*
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
 
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 GLubyte* data = (GLubyte*)malloc( _w * _h * 4 );
 
 CGContextRef context = CGBitmapContextCreate( data, _w, _h, 8, 4 * _w, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big );
 CGColorSpaceRelease( colorSpace );
 CGContextClearRect( context, CGRectMake( 0, 0, _w, _h ) );
 //CGContextTranslateCTM( context, 0, height - height );
 
 CGContextTranslateCTM(context, 0, _h);
 CGContextScaleCTM(context, 1, -1);
 
 CGContextDrawImage( context, CGRectMake( 0, 0, _w, _h ), image.CGImage );
 
 CGContextRelease(context);
 
 [texData release];
 
 return new Texture(data, _w, _h);
 
 }
 */
//
//AVAssetReader* assetReader;
//AVAssetReaderTrackOutput* trackOutput;
//AVAsset *currentAsset;
//CMSampleBufferRef pixelBuffer;

void ResourceHandler::ProcessPixelBuffer() const {
  printf("in processPixelBuff...\n");
}


void ResourceHandler::HandlePlayback(Texture* videoTexture, bool isLooping) {
  
  /*
   if ([assetReader status]==AVAssetReaderStatusReading) {
   videoTexture->Bind(GL_TEXTURE0);
   
   AVAssetReaderTrackOutput* output = [assetReader.outputs objectAtIndex:0];
   pixelBuffer = [output copyNextSampleBuffer];
   CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(pixelBuffer);
   CVPixelBufferLockBaseAddress(imageBuffer, 0 ); 
   unsigned char *linebase = (unsigned char*)CVPixelBufferGetBaseAddress(imageBuffer);
   CMFormatDescriptionRef formatDesc = CMSampleBufferGetFormatDescription(pixelBuffer);
   CMVideoDimensions videoDimensions = CMVideoFormatDescriptionGetDimensions(formatDesc); 
   
   //Texture::flipBufferY(linebase, videoDimensions.width, videoDimensions.height);
   
   glTexSubImage2D(videoTexture->kind, 0, 0, 0, videoDimensions.width, videoDimensions.height, GL_BGRA, GL_UNSIGNED_BYTE, linebase); 
   
   CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
   CVPixelBufferRelease(imageBuffer);
   free(pixelBuffer);
   
   videoTexture->Unbind(GL_TEXTURE0);
   
   } else if ([assetReader status] == AVAssetReaderStatusCompleted) {
   [assetReader cancelReading];
   if (isLooping) {
   Replay();
   }
   }
   */
}


void ResourceHandler::Replay() {
  /*
   NSArray* tracksArray = [currentAsset tracksWithMediaType:AVMediaTypeVideo];
   AVAssetTrack* videoTrack = [tracksArray objectAtIndex:0];
   trackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
   NSError *error = nil;
   assetReader = [AVAssetReader assetReaderWithAsset:currentAsset error:&error];
   [assetReader retain];
   if (error) {
   NSLog(@"%@",[error localizedDescription]);
   }
   
   [assetReader addOutput:trackOutput];
   [assetReader startReading];
   */
}


Texture* ResourceHandler::CreateVideoTexture(const string &fname) {
  /*
   NSString* basePath = [[NSString alloc] initWithUTF8String:fname.c_str()];
   NSArray* splits = [basePath componentsSeparatedByString: @"."];
   
   NSString* fileStr = [splits objectAtIndex:0];
   NSString* typeStr = [splits objectAtIndex:1];
   
   NSLog(@"Loading texture: %@.%@\n", fileStr, typeStr);
   NSString* path = [[NSBundle mainBundle] pathForResource:fileStr ofType:typeStr];
   
   if (path == NULL) {
   printf("Could not find texture inside of bundle...\n");
   return NULL;
   }
   
   currentAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
   
   
   
   //   printf("1. in LoadVideoTest() ... \n");
   //   NSString* fileStr = @"Luigi-Text-v4-Bro";
   //   NSString* typeStr = @"mp4";
   //   
   //   NSString* path = [[NSBundle mainBundle] pathForResource:fileStr ofType:typeStr];
   //   NSLog(@"Loading texture: %@.%@\n", fileStr, typeStr);
   //   
   //   currentAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
   //   
   NSArray* tracksArray = [currentAsset tracksWithMediaType:AVMediaTypeVideo];
   AVAssetTrack* videoTrack = [tracksArray objectAtIndex:0];
   trackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:videoTrack outputSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
   NSError *error = nil;
   assetReader = [AVAssetReader assetReaderWithAsset:currentAsset error:&error];
   [assetReader retain];
   if (error) {
   NSLog(@"%@",[error localizedDescription]);
   }
   
   [assetReader addOutput:trackOutput];
   [assetReader startReading];
   
   CGSize size = videoTrack.naturalSize;
   printf("VIDEO size = %f %f\n", size.width, size.height);
   
   return Texture::CreateEmptyTexture(size.width, size.height, GL_BGRA, GL_UNSIGNED_BYTE);
   
   //return Texture::CreateEmptyTexture(size.width, size.height);
   
   //Texture* videoTexture = [[Texture alloc] initEmptyTextureWidth:size.width andHeight:size.height];
   */
  return NULL;
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


