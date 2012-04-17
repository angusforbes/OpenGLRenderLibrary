
#import "Defines.h"
#import "AppDelegate.h"
#import "NSGLView.h"
#include "RendererFriendGroups.hpp"

@implementation AppDelegate
@synthesize nsview;
@synthesize glview;
@synthesize window;




- (void*) GetRenderer {
  //initialize the specific renderer
	//_renderer = [[RendererBasic alloc] initRenderer:self];
  //_renderer = [[RendererNavierStokes alloc] initRenderer:self];
  //_renderer = [[RendererMetaball alloc] initRenderer:self];
  //_renderer = [[RendererBoundary alloc] initRenderer:self];
  //m_renderer = new RendererTexture3D(); //...1
  //m_renderer = new RendererPanoramic();
  //m_renderer = new RendererTest(); //...1
  //m_renderer = new RendererFluidAutomata3D(); //...1
  //m_renderer = new RendererGrating(); //...1
  //m_renderer = new RendererGratingBubble(); //...1
  //m_renderer = new RendererColorCues(); //...1
  //m_renderer = new RendererFriendGroups(); //...1

  
  return new RendererFriendGroups();
}


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

- (void) dealloc {
  [glview release];
  [window release];
  [super dealloc];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
  printf("HERERERER\n");
  return NSTerminateNow;
 
  /*
  [[window contentView] dealloc];
 
  if (1 == 1) {
    return NSTerminateLater;
  } else {
    return NSTerminateNow;
  }
  */
}



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  NSRect rect = [glview bounds];
  printf("glview bounds = %f/%f\n", rect.size.width, rect.size.height);
  NSRect rect2 = [nsview bounds];
  printf("nsview bounds = %f/%f\n", rect2.size.width, rect2.size.height);
  

  //exit(0);
}
/*
- (void) toggleTitleBar {
  
  if ([window styleMask] == NSBorderlessWindowMask) {
    [window setStyleMask:NSTitledWindowMask];   
    CGDisplayShowCursor(kCGDirectMainDisplay);

  } else {
  
  [window setStyleMask:NSBorderlessWindowMask];
    NSRect frame = [window frame];

    frame.origin.y = 0;
    frame.size.height = 1024;
    frame.origin.x = 0;
    frame.size.height = 768;
    
    [window setFrame: frame
             display: YES
             animate: YES];
    
    CGDisplayHideCursor(kCGDirectMainDisplay);
    
  }
}

- (NSWindow *) getTheWindow {
  return window; 
}
 */
@end
