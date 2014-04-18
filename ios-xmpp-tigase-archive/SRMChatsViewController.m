//
//  SRMChatsViewController.m
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import "SRMChatsViewController.h"
#import "SRMAppDelegate.h"
#import "SRMMessageViewController.h"

@interface SRMChatsViewController (){
    NSString *chatName;
}

@end

@implementation SRMChatsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - my method
- (SRMAppDelegate *)appDelegate
{
    SRMAppDelegate *delegate =  (SRMAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.SRMChatDelegate = self;
	return delegate;
}

#pragma mark - Chat Delegate
- (void)buddyUpdates
{
    [self.tableView reloadData];
}


#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self appDelegate]_buddies].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[[self appDelegate]_buddies] objectAtIndex: indexPath.row];
    cell.detailTextLabel.text = @"On Line";
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *_username = (NSString *)[[[self appDelegate]_buddies] objectAtIndex:indexPath.row];
        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", _username, [self appDelegate].server]];
        [[[self appDelegate] xmppRoster] removeUser:jid];
        
        [[[self appDelegate]_buddies] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //start a Chat
    chatName = (NSString *)[[[self appDelegate]_buddies] objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"start_chat" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"start_chat"]) {
        
        SRMMessageViewController *msgController = segue.destinationViewController;
        
        msgController.title = chatName;
    }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (IBAction)backToChats:(UIStoryboardSegue *)segue
{
}

@end
