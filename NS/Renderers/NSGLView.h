
#import <Cocoa/Cocoa.h>
#import <QuartzCore/CVDisplayLink.h>
#import <Carbon/Carbon.h>

#import "Renderer.hpp"


@interface NSGLView : NSOpenGLView {
	CVDisplayLinkRef displayLink;
  NSTimeInterval prevTick;
  Renderer* m_renderer;
}

@property bool isDragging;
@property bool isPressing;
@property NSPoint currmouse;
@property NSPoint prevmouse;

- (void) cleanup;

@end
