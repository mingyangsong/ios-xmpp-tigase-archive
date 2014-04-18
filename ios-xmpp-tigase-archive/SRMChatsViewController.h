//
//  SRMChatsViewController.h
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRMChatDelegate.h"

@interface SRMChatsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SRMChatDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backToChats:(UIStoryboardSegue *)segue;

@end
