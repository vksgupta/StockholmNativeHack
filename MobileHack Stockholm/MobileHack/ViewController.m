//
//  ViewController.m
//  MobileHack
//
//  Created by Aryeh Selekman on 3/5/12.
//  Copyright (c) 2012 Facebook. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController
@synthesize welcomeLabel;
@synthesize authButton;
@synthesize postButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)authButtonClicked:(id)sender 
{
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([[delegate facebook] isSessionValid]) {
        [delegate logout];
    } else {
        [delegate login];
    }
}

- (IBAction)postButtonClicked:(id)sender
{
    AppDelegate *delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    if ([[delegate facebook] isSessionValid]) {
        [delegate post];
    }

}

@end
