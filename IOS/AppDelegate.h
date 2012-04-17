

#import <UIKit/UIKit.h>
//#include "Renderer.hpp"

#include "ViewController.h"

@class IOSGLView;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
  UIWindow *window;
  ViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

- (void*) GetRenderer;

@end
