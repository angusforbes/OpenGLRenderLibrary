
#import "Defines.h"
#import "AppDelegate.h"
#import "NSGLView.h"

@implementation AppDelegate
@synthesize nsview;
@synthesize glview;
@synthesize window;


- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
  return YES;
}

- (void) dealloc
{
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
  

 // exit(0);
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
