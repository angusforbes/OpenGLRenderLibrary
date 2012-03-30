

#import "NSGLView.h"

#import "RendererTest.hpp"
#import "RendererTexture3D.hpp"
#import "RendererPanoramic.hpp"
#import "RendererFluidAutomata3D.hpp"
#import "RendererGrating.hpp"
#import "RendererGratingBubble.hpp"
#import "RendererColorCues.hpp"

@interface NSGLView (PrivateMethods)
- (void) initGL;
- (void) initRenderer;
- (void) drawView;
@end


@implementation NSGLView

@synthesize isDragging;
@synthesize isPressing;
@synthesize currmouse;
@synthesize prevmouse;

//@synthesize m_renderer;

- (void) initRenderer {
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
  m_renderer = new RendererColorCues(); //...1
  
  NSRect rect = [self bounds];
  m_renderer->width = rect.size.width;
  m_renderer->height = rect.size.height;
  m_renderer->Initialize();
}

- (void) initGL {
  
  printf("2. in initGL\n");
  
	// Make this openGL context current to the thread
	// (i.e. all openGL on this thread calls will go to this context)
  //[[self openGLContext] setFullScreen]; 
	[[self openGLContext] makeCurrentContext];
	
	// Synchronize buffer swaps with vertical refresh rate
	GLint swapInt = 1;
	[[self openGLContext] setValues:&swapInt forParameter:NSOpenGLCPSwapInterval];
	
  [self initRenderer];
}

- (CVReturn) getFrameForTime:(const CVTimeStamp*)outputTime
{
	// There is no autorelease pool when this method is called 
	// because it will be called from a background thread
	// It's important to create one or you will leak objects
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[self drawView];
	
	[pool release];
	return kCVReturnSuccess;
}

// This is the renderer output callback function
static CVReturn MyDisplayLinkCallback(CVDisplayLinkRef displayLink, const CVTimeStamp* now, const CVTimeStamp* outputTime, CVOptionFlags flagsIn, CVOptionFlags* flagsOut, void* displayLinkContext)
{
    CVReturn result = [(NSGLView*)displayLinkContext getFrameForTime:outputTime];
    return result;
}

- (BOOL)acceptsFirstResponder {
  return YES;
}


- (void)mouseEntered:(NSEvent *)mouseEvent {
   currmouse = [self convertPoint:[mouseEvent locationInWindow] fromView:nil];
   printf("mouseEntered: %f/%f\n", currmouse.x, currmouse.y);
}
- (void)mouseExited:(NSEvent *)mouseEvent{
  currmouse = [self convertPoint:[mouseEvent locationInWindow] fromView:nil];
  //printf("mouseExited: %f/%f\n", currmouse.x, currmouse.y);
}
- (void)mouseMoved:(NSEvent *)mouseEvent{
  //currmouse = [self convertPoint:[mouseEvent locationInWindow] fromView:nil];
  //printf("mouseMoved: %f/%f\n", currmouse.x, currmouse.y);
  //isDragging = true;
}


- (void)mouseDragged:(NSEvent*)mouseEvent {
  currmouse = [self convertPoint:[mouseEvent locationInWindow] fromView:nil];
  
  if (currmouse.x == prevmouse.x && currmouse.y == prevmouse.y) {
    return;
    isDragging = NO;
  }
  //printf("mouseDragged %f/%f\n", currmouse.x, currmouse.y);
  isDragging = YES;
  
  m_renderer->HandleTouchMoved(ivec2(prevmouse.x, prevmouse.y), ivec2(currmouse.x, currmouse.y));
  
}

- (void)mouseUp:(NSEvent*)mouseEvent {
  isDragging = NO;
  isPressing = NO;
}

- (void)mouseDown:(NSEvent*)mouseEvent {
  
  
  if ([mouseEvent modifierFlags] & NSControlKeyMask) { 
    printf("control w/mouse\n");
  } else if ([mouseEvent modifierFlags] & NSAlternateKeyMask) {
    printf("alt w/mouse\n");
  } else if ([mouseEvent modifierFlags] & NSCommandKeyMask) {
    printf("command w/mouse\n");
  } else if ([mouseEvent modifierFlags] & NSShiftKeyMask) {
    printf("shift w/mouse\n");
  } else {
    printf("mouse\n");
  }
  
  currmouse = [self convertPoint:[mouseEvent locationInWindow] fromView:nil];
  //printf("%f/%f\n", currmouse.x, currmouse.y);  
  prevmouse = NSMakePoint(currmouse.x, currmouse.y);
  
  isDragging = NO;
  isPressing = YES;
  
  m_renderer->HandleTouchBegan(ivec2(currmouse.x, currmouse.y));

  //location.y = camera.viewHeight - location.y;
}
 


- (void)keyDown:(NSEvent*)keyDownEvent {
  
  char key = [keyDownEvent keyCode];

  if (key == kVK_Escape) {
    printf("quitting...");
    exit(0);
  }
  
  bool shift = false;
  bool control = false;
  bool command = false;
  bool option = false;
  bool function = false;
  
  if ([keyDownEvent modifierFlags] & NSShiftKeyMask) {
    shift = true;
  }
  if ([keyDownEvent modifierFlags] & NSControlKeyMask) {
    control = true;
  }
  if ([keyDownEvent modifierFlags] & NSAlternateKeyMask) {
    option = true;
  }
  if ([keyDownEvent modifierFlags] & NSCommandKeyMask) {
    command = true;
  }
  if ([keyDownEvent modifierFlags] & NSFunctionKeyMask) {
    function = true;
  }
 // printf("command/shift/option/control/func = %d/%d/%d/%d/%d\n", command, shift, option, control, function);
  
  m_renderer->HandleKeyDown(key, shift, control, command, option, function);
  
  /*
    printf("changing mode...\n");
    
    switch(key) {
      case kVK_ANSI_1:
        interactMode = modeVector;
        return;      
      case kVK_ANSI_2:
        interactMode = modeColor;
        return;
      case kVK_ANSI_3:
        interactMode = modePreset;
        return;
      case kVK_ANSI_4:
        interactMode = modeMixIn;
        return;

      case kVK_ANSI_S:
      case kVK_ANSI_W:
        printf("writing to disk...");

        saveOutput = YES;
        return;
        
      default:
        break;
    }
    
  }
  
  
  
  switch(interactMode) {
    case modeVector:
      [self handleVectorInteraction:keyDownEvent];   
      break;
    case modeColor:
      [self handleColorInteraction:keyDownEvent];   
      break;
    case modePreset:
      [self handlePresetInteraction:keyDownEvent];   
      break;
    case modeMixIn:
      //[self handleMixInInteraction:keyDownEvent];   
      break;

    default:
      break;
  }
        
  [self handleMixInInteraction:keyDownEvent];
    
 
  
//	// Get pressed key (code)
//	NSString * character = [keyDownEvent characters];
//  keyCode = [character characterAtIndex: 0];
//  
//  printf("keycode = %d\n", keyCode);
//  
  */
   //keyIsPressed = YES;
}


-(void)viewDidMoveToWindow {
  [[self window] makeFirstResponder:self];
  [[self window] setAcceptsMouseMovedEvents:YES];

}

- (id) initWithFrame:(NSRect)frameRect {
  NSOpenGLPixelFormatAttribute attrs[] =
	{
    //NSOpenGLPFAAccelerated,
    //NSOpenGLPFANoRecovery,
    NSOpenGLPFADoubleBuffer,
    NSOpenGLPFADepthSize, 24,
    0
    
    //		NSOpenGLPFADoubleBuffer,
    //		NSOpenGLPFADepthSize, 
    //    24,
    //		0
	};
	
	NSOpenGLPixelFormat *pf = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
	
	if (!pf) {
		NSLog(@"In NSGLView.initWithFrame : No OpenGL pixel format");
    exit(0);
	}
	
	self = [super initWithFrame:frameRect pixelFormat:[pf autorelease]];
  
  
  self.isDragging = NO;
  self.currmouse = NSMakePoint(0.0, 0.0);
  self.prevmouse = NSMakePoint(0.0, 0.0);
  
 	return self;
}


- (void) prepareOpenGL {
  
	[super prepareOpenGL];
	
	[self initGL];
	
	// Create a display link capable of being used with all active displays
	CVDisplayLinkCreateWithActiveCGDisplays(&displayLink);
	
	// Set the renderer output callback function
	CVDisplayLinkSetOutputCallback(displayLink, &MyDisplayLinkCallback, self);
	
	// Set the display link for the current renderer
	CGLContextObj cglContext = (CGLContextObj)[[self openGLContext] CGLContextObj];
	
  //CGLContextObj cglContext = [[self openGLContext] CGLContextObj];
	
  CGLPixelFormatObj cglPixelFormat = (CGLPixelFormatObj)[[self pixelFormat] CGLPixelFormatObj];
	CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, cglContext, cglPixelFormat);
	
	// Activate the display link
	CVDisplayLinkStart(displayLink);
  startTick = [NSDate timeIntervalSinceReferenceDate];

}

- (void) reshape {	
  printf("4. in [NSGLView reshape]\n");
  
  
	[super reshape];
	
	// We draw on a secondary thread through the display link
	// When resizing the view, -reshape is called automatically on the main thread
	// Add a mutex around to avoid the threads accessing the context simultaneously when resizing
  
 	CGLLockContext( ( CGLContextObj)[[self openGLContext] CGLContextObj]);
	
    NSRect rect = [self bounds];
   // printf("new size = %f/%f\n", rect.size.width, rect.size.height);
   m_renderer->Reshape((int)rect.size.width, (int)rect.size.height);
  CGLUnlockContext((CGLContextObj) [[self openGLContext] CGLContextObj]);
	
}

bool timeToDie = false;

- (float) getTotalTime {
  return (curTick - startTick);
}


- (void) drawView {	 

  //printf("5. in drawView\n");
  
	curTick = [NSDate timeIntervalSinceReferenceDate];
	deltaTime = curTick - prevTick;
  fps = (1.0/deltaTime);
  //printf("frame time = %f, fps = %f\n", deltaTime, (1.0/deltaTime));
  
  
	prevTick = curTick;

  //[[self openGLContext] setFullScreen]; //doesn't seem to be working... what did i do in ServerFluidAutomata?
  [[self openGLContext] makeCurrentContext];

	// We draw on a secondary thread through the display link
	// When resizing the view, -reshape is called automatically on the main thread
	// Add a mutex around to avoid the threads accessing the context simultaneously	when resizing
  
  CGLContextObj cglContext = (CGLContextObj) [[self openGLContext] CGLContextObj];
  CGLLockContext(cglContext);
		
  m_renderer->Render();

	CGLFlushDrawable((CGLContextObj)[[self openGLContext] CGLContextObj]);
	CGLUnlockContext((CGLContextObj)[[self openGLContext] CGLContextObj]);
 
  if (timeToDie == true) {
    [self cleanup];
    exit(0);
  }
}

- (void) cleanup {
  printf("here in nsglview cleanup\n");
  m_renderer->Cleanup();
}

- (void) dealloc {	
	printf("in dealloc?????\n");
////	[_renderer release];

  //free(m_renderer);
	// Release the display link
	CVDisplayLinkRelease(displayLink);
	
	[super dealloc];
}

/*
- (void)keyDown:(NSEvent*)keyDownEvent {
//  [self dealloc];
//  [self cleanup];
  //exit(0);
  //timeToDie = true;
}
*/

@end
