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
    XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPReconnect *xmppReconnect;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
    NSString *username;
    NSString *password;
    NSString *server;
}

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPRoster *xmppRoster;
@property (nonatomic, strong) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingCoreDataStorage;
@property (nonatomic, strong) XMPPMessageArchiving *xmppMessageArchivingModule;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) id SRMChatDelegate;
@property (nonatomic, assign) id SRMMessageDelegate;
@property (nonatomic, assign) id SRMRequestDelegate;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSMutableArray *_buddies;
@property (nonatomic, strong) NSMutableArray *_requests;

-(BOOL)connect;
-(void)disconnect;
-(void)setupStream;
-(void)goOnline;
-(void)goOffline;

@end
