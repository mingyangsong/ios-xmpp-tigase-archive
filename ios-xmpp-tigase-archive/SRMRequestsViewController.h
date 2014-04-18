//
//  SRMRequestsViewController.h
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRMRequestDelegate.h"

@interface SRMRequestsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SRMRequestDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backToRequests:(UIStoryboardSegue *)segue;

@end
