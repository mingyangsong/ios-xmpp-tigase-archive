//
//  SRMRequestsViewController.m
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import "SRMRequestsViewController.h"
#import "SRMAppDelegate.h"

@interface SRMRequestsViewController ()

@end

@implementation SRMRequestsViewController

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
    return [[self appDelegate]_requests].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *_username = [[[self appDelegate]_requests] objectAtIndex:[indexPath row]];
    cell.textLabel.text = [_username substringToIndex:[_username length] - 20];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        XMPPJID *jid = [XMPPJID jidWithString:[[[self appDelegate]_requests] objectAtIndex:indexPath.row]];
        [[[self appDelegate] xmppRoster] rejectPresenceSubscriptionRequestFrom:jid];
    
        [[[self appDelegate]_requests] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMPPJID *jid = [XMPPJID jidWithString:[[[self appDelegate]_requests] objectAtIndex:indexPath.row]];
    [[[self appDelegate] xmppRoster] acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    [[[self appDelegate]_buddies] addObject:[jid.bareJID user]];
    
    [[[self appDelegate]_requests] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)backToRequests:(UIStoryboardSegue *)segue
{
    
}

@end
