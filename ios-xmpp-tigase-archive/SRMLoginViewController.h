//
//  SRMLoginViewController.h
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRMLoginViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;


- (IBAction)loginClick:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)backToLogin:(UIStoryboardSegue *)segue;

@end
