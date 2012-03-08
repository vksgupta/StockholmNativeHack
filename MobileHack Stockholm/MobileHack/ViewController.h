//
//  ViewController.h
//  MobileHack
//
//  Created by Aryeh Selekman on 3/5/12.
//  Copyright (c) 2012 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (retain, nonatomic) IBOutlet UIButton *authButton;
@property (retain, nonatomic) IBOutlet UIButton *postButton;

- (IBAction)authButtonClicked:(id)sender;
- (IBAction)postButtonClicked:(id)sender;

@end
