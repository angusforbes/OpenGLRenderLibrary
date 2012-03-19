#include <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>


@class NSGLView;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
 
}

//@property (assign) IBOutlet NSWindow *window;
//@property (assign) IBOutlet NSGLView *glview;
//@property (assign) IBOutlet NSView *nsview;
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSView *nsview;
@property (assign) IBOutlet NSGLView *glview;

@end
