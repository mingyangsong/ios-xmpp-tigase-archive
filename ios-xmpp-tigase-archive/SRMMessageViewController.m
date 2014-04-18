//
//  SRMMessageViewController.m
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import "SRMMessageViewController.h"
#import "SRMAppDelegate.h"

@interface SRMMessageViewController (){
    NSMutableArray *_messages;
    NSInteger _count;
}

@end

@implementation SRMMessageViewController
@synthesize title;

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
    
    _count = 0;
    self.navigationItem.title = title;
    [self.navigationBar pushNavigationItem:self.navigationItem animated:NO];
    
    _messages = [[NSMutableArray alloc]init];
    [self getMessageData];
    [self performSelector:@selector(goToBottom) withObject:nil];
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
    delegate.SRMMessageDelegate = self;
	return delegate;
}

- (void)getMessageData
{
    NSManagedObjectContext *context = [[self appDelegate].xmppMessageArchivingCoreDataStorage mainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    NSError *error;
    
    NSArray *messages = [context executeFetchRequest:request error:&error];
    
    while (_count != 0 && [messages count] <= _count)
    {
        messages = [context executeFetchRequest:request error:&error];
    }
    _count = [messages count];
    [_messages removeAllObjects];
    [_messages addObjectsFromArray:messages];
}

- (void)updateMessage
{
    [self getMessageData];
    [self.tableView reloadData];
    [self performSelector:@selector(goToBottom) withObject:nil afterDelay:.5];
}


-(void)goToBottom
{
    NSIndexPath *lastIndexPath = [self lastIndexPath];
    [self.tableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

-(NSIndexPath *)lastIndexPath
{
    NSInteger lastSectionIndex = MAX(0, [self.tableView numberOfSections] - 1);
    NSInteger lastRowIndex = MAX(0, [self.tableView numberOfRowsInSection:lastSectionIndex] - 1);
    return [NSIndexPath indexPathForRow:lastRowIndex inSection:lastSectionIndex];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Configure the cell...
    XMPPMessageArchiving_Message_CoreDataObject *object = [_messages objectAtIndex:indexPath.row];
    NSMutableString *showString = [[NSMutableString alloc] init];
    if (object.body) {
        [showString appendFormat:@"%@\n",object.body];
    }
    if (object.isOutgoing) {
        [showString appendFormat:@"to: "];
    }else{
        [showString appendFormat:@"from: "];
    }
    if (object.bareJidStr) {
        [showString appendFormat:@"%@\n",[object.bareJidStr substringToIndex:[object.bareJidStr length] - 20]];
    }
    if (object.timestamp) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        [showString appendFormat:@"%@",[formatter stringFromDate:object.timestamp]];
    }
    
    cell.textLabel.numberOfLines = 100;
    cell.textLabel.text = showString;
    
    return cell;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)sendClick:(id)sender {
    if ([self.messageTextField.text length] > 0) {
        XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", self.title, [self appDelegate].server]];
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to: jid];
        [message addAttributeWithName:@"from" stringValue: [NSString stringWithFormat:@"%@@%@/ios", [self appDelegate].username, [self appDelegate].server]];
        [message addBody:self.messageTextField.text];
        [[[self appDelegate] xmppStream] sendElement:message];
        
        [self.messageTextField resignFirstResponder];
        [self.messageTextField setText:nil];
    }
    [self updateMessage];
}

@end
