

#import "ViewController.h"
#import "IOSGLView.h"
@implementation ViewController

- (id)initWithFrame:(CGRect)_screenBounds {
  if (self = [super init]) {

    screenBounds = _screenBounds;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    return self;
  }
  return NULL;
}


- (void)loadView {
  /*
  printf("in loadView.............\n");
  self.view = [[IOSGLView alloc] initWithFrame: screenBounds];  
  Renderer::GetRenderer()->AddUI();
  
  printf("in load view\n");
  */
}

- (void) orientationChanged:(NSNotification *)notification {	
  
  //printf("in AppDelegate:orientationChanged 2 \n");
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  
  switch (orientation) {
    case UIDeviceOrientationLandscapeLeft:
      NSLog(@"Landscape Left!");
      // CURRENT_ORIENTATION = orientation;
      break;
    case UIDeviceOrientationLandscapeRight:
      NSLog(@"Landscape Right!");
      //CURRENT_ORIENTATION = orientation;
      break;
    case UIDeviceOrientationPortrait:
      NSLog(@"Portrait Normal!");
      //CURRENT_ORIENTATION = orientation;
      break;
    case UIDeviceOrientationPortraitUpsideDown:
      NSLog(@"Portrait Upside Down!");
      //CURRENT_ORIENTATION = orientation;
      break;
    default:
      break;
  }
  
  //printf("CURRENT_ORIENTATION = %d\n", CURRENT_ORIENTATION);
  
  
  
  //no matter what, save the screen size!
  //[self setCurrentBounds];
  
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  self.view = [[IOSGLView alloc] initWithFrame: screenBounds];  

  [super viewDidLoad];
  printf("view did load\n");
  Renderer::GetRenderer()->isReady = true;
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

/*
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  
  printf("rotating!!!\n");
}
*/

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
  return YES;
  //    // Return YES for supported orientations
  //    return (interfaceOrientation == UIInterfaceOrientationPortrait);

}



@end
 
