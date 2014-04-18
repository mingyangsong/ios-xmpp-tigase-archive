//
//  SRMAddViewController.m
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import "SRMAddViewController.h"
#import "SRMAppDelegate.h"

@interface SRMAddViewController ()

@end

@implementation SRMAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *_username = self.buddyTextField.text;
    if(_username)
    {
         XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@/ios", _username, [self appDelegate].server]];
        [[[self appDelegate] xmppRoster] addUser:jid withNickname:_username];
    }
}

- (SRMAppDelegate *)appDelegate
{
    return (SRMAppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
