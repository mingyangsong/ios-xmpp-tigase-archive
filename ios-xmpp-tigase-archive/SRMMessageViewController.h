//
//  SRMMessageViewController.h
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRMMessageDelegate.h"

@interface SRMMessageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SRMMessageDelegate>


@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (copy, nonatomic) NSString *title;

- (IBAction)sendClick:(id)sender;

@end
