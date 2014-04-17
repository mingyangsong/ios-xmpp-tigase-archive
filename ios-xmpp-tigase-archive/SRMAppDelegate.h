//
//  SRMAppDelegate.h
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/16/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"

@interface SRMAppDelegate : UIResponder <UIApplicationDelegate>
{
    XMPPStream *xmppStream;
    XMPPRoster *xmppRoster;
    XMPPReconnect *xmppReconnect;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
}

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchivingModule;

@property (strong, nonatomic) UIWindow *window;

@end
