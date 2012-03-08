//
//  AppDelegate.m
//  MobileHack
//
//  Created by Aryeh Selekman on 3/5/12.
//  Copyright (c) 2012 Facebook. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize facebook;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [facebook release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    facebook = [[Facebook alloc] initWithAppId:@"374038142615411"
                                   andDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    if ([facebook isSessionValid]) {
        [self fbDidLogin];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void) login {
    [facebook authorize:nil];
}

- (void) logout {
    [facebook logout];
}

// Implement session delegate methods
- (void)fbDidLogin {
    self.viewController.welcomeLabel.text = @"Welcome ...";
    [self.viewController.authButton setImage:[UIImage imageNamed:@"FBConnect.bundle/images/LogoutNormal.png"] forState:UIControlStateNormal];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self.viewController.postButton setHidden:NO];
    
    // Personalize
    [self apiGraphMe];
}

- (void)fbDidLogout {
    self.viewController.welcomeLabel.text = @"Login to continue";
    [self.viewController.authButton setImage:[UIImage imageNamed:@"FBConnect.bundle/images/LoginWithFacebookNormal.png"] forState:UIControlStateNormal];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)fbDidNotLogin:(BOOL)cancelled {
}

- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt {
}


- (void)fbSessionInvalidated {
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url];
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *query = [url fragment];
    NSDictionary *params = [self parseURLParams:query];
    // Check if target URL exists
    NSString *targetURLString = [params valueForKey:@"target_url"];
    if (targetURLString) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Deep Link!"
                              message:[NSString stringWithFormat:@"Incoming: %@", @"Deep Link"]
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
        [alert show];
        [alert release];
    }
    return [facebook handleOpenURL:url];
}

/*
 * Graph API: Get the user's basic information, picking the name and picture fields.
 */
- (void)apiGraphMe {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"name",  @"fields",
                                   nil];
    [facebook requestWithGraphPath:@"me" andParams:params andDelegate:self];
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    self.viewController.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@", [result objectForKey:@"name"]];
}

- (void) post {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"I'm using the Hackbook for iOS app", @"name",
                                   @"Hackbook for iOS.", @"caption",
                                   @"Check out Hackbook for iOS to learn how you can make your iOS apps social using Facebook Platform.", @"description",
                                   @"http://www.tunedon.com/texto", @"link",
                                   nil];
    
    
    [facebook dialog:@"feed" andParams:params andDelegate:self];
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[[NSMutableDictionary alloc] init]
                                   autorelease];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1]
                         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

@end
