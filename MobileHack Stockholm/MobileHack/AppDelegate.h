//
//  AppDelegate.h
//  MobileHack
//
//  Created by Aryeh Selekman on 3/5/12.
//  Copyright (c) 2012 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate,
FBRequestDelegate, FBDialogDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (nonatomic, retain) Facebook *facebook;

- (void) login;
- (void) logout;
- (void) apiGraphMe;
- (void) post;
- (NSDictionary*) parseURLParams:(NSString *)query;
@end
