
#import <Foundation/Foundation.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVFoundation.h>
#import "Texture.hpp"

@interface VideoManager : NSObject {

@public
  AVAsset* videoAsset;
  AVAssetReader* videoAssetReader;
  AVAssetTrack* videoTrack;
  AVAssetReaderTrackOutput* videoTrackOutput;
  Texture* videoTexture;
  CMSampleBufferRef pixelBuffer;
  double prevTime;
  double currTime;
  bool isLooping;

}

- (Texture*) setUpVideoThread:(AVAsset*)_inAsset isLooping:(bool)_isLooping;
- (void) startVideoThread:(double)fireDate;
- (void) nextVideoFrame;

//private
//- (void) playVideo;

@end
