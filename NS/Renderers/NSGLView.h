
#import <Cocoa/Cocoa.h>
#import <QuartzCore/CVDisplayLink.h>
#import <Carbon/Carbon.h>

#import "Renderer.hpp"


@interface NSGLView : NSOpenGLView {
	CVDisplayLinkRef displayLink;
  NSTimeInterval prevTick;
  NSTimeInterval startTick;
  NSTimeInterval curTick;
  NSTimeInterval deltaTime;
  float fps;
  Renderer* m_renderer;
}


@property bool isDragging;
@property bool isPressing;
@property NSPoint currmouse;
@property NSPoint prevmouse;

- (float) getTotalTime;
- (void) cleanup;

@end
