//
//  SRMLoginViewController.m
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import "SRMLoginViewController.h"
#import "SRMAppDelegate.h"

@interface SRMLoginViewController ()

- (BOOL)informationValidate;

@end

@implementation SRMLoginViewController

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - my methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (SRMAppDelegate *)appDelegate
{
	return (SRMAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)informationValidate
{
    if (self.usernameTextField.text && self.passwordTextField.text )
    {
        [[NSUserDefaults standardUserDefaults]setObject:self.usernameTextField.text forKey:xmppUsername];
        [[NSUserDefaults standardUserDefaults]setObject:self.passwordTextField.text forKey:xmppPassword];
        return YES;
    }
    
    return NO;
}

- (IBAction)loginClick:(id)sender
{
    if ([self informationValidate])
    {
        [[self appDelegate] connect];
    }
    
//    while (![[[self appDelegate] xmppStream] isConnected])
//    {
//        NSLog(@"Wait Connect");
//    }
    
    while ([[[self appDelegate] xmppStream] isDisconnected])
    {
        NSLog(@"Wait Connect");
    }
    
    if([[[self appDelegate]xmppStream] supportsInBandRegistration])
    {
        NSError *error;
        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@/ios", [[self appDelegate] username], [[self appDelegate] server]]];
        [[[self appDelegate] xmppStream] setMyJID: jid];
        if (![[self appDelegate].xmppStream registerWithPassword:self.passwordTextField.text error:&error])
        {
            NSLog(@"error authenticate : %@",error.description);
        }
    }
    
    [self performSegueWithIdentifier:@"login_success" sender:sender];
}

- (IBAction)backgroundTap:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)backToLogin:(UIStoryboardSegue *)segue
{
    [[self appDelegate] disconnect];
    while ([[[self appDelegate] xmppStream] isConnected])
    {
        NSLog(@"Wait Disconnect");
    }
    while (![[[self appDelegate] xmppStream] isDisconnected])
    {
        NSLog(@"Wait Disconnect");
    }
}

@end
