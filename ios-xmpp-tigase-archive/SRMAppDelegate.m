//
//  SRMAppDelegate.m
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/16/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import "SRMAppDelegate.h"
#import "DDTTYLogger.h"

@implementation SRMAppDelegate
@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppReconnect;
@synthesize xmppMessageArchivingCoreDataStorage;
@synthesize xmppMessageArchivingModule;
@synthesize username;
@synthesize password;
@synthesize server;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSUserDefaults standardUserDefaults] setObject:@"chat.carbonhire.com" forKey:xmppServer];
    // Open the raw XML log
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - xmpp
- (void)setupStream
{
    xmppStream = [[XMPPStream alloc]init];
    #if !TARGET_IPHONE_SIMULATOR
    {
        xmppStream.enableBackgroundingOnSocket = YES;
    }
    #endif
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppReconnect = [[XMPPReconnect alloc]init];
    [xmppReconnect activate:self.xmppStream];
    
    [xmppRoster activate:self.xmppStream];
    [xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    xmppMessageArchivingCoreDataStorage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    xmppMessageArchivingModule = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:xmppMessageArchivingCoreDataStorage];
    [xmppMessageArchivingModule setClientSideMessageArchivingOnly:YES];
    [xmppMessageArchivingModule activate:xmppStream];
    [xmppMessageArchivingModule addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)goOnline
{
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

- (BOOL)connect
{
    [self setupStream];
    
    username = [[NSUserDefaults standardUserDefaults] stringForKey:xmppUsername];
    password = [[NSUserDefaults standardUserDefaults] stringForKey:xmppPassword];
    server = [[NSUserDefaults standardUserDefaults] stringForKey:xmppServer];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    
    if (username == nil || password == nil) {
        return NO;
    }
    
    XMPPJID *jid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@/ios", username, server]];
    [xmppStream setMyJID:jid];
    
    NSError *error;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        NSLog(@"my connected error : %@", error.description);
        return NO;
    }
    
    return YES;
}

- (void)disconnect
{
    [self goOffline];
    [xmppStream disconnect];
}

#pragma mark - XMPPStreamDelegate
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSError *error;
    if (![self.xmppStream authenticateWithPassword:password error:&error])
    {
        NSLog(@"error authenticate : %@",error.description);
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSError *error;
    if (![self.xmppStream authenticateWithPassword:password error:&error])
    {
        NSLog(@"error authenticate : %@",error.description);
    }
    else
    {
        // Setup Server Side Message Archive
        XMPPIQ *iq = [[XMPPIQ alloc] initWithType:@"set"];
        [iq addAttributeWithName:@"id" stringValue:@"auto1"];
        NSXMLElement *query = [NSXMLElement elementWithName:@"auto" xmlns:@"urn:xmpp:archive"];
        [query addAttributeWithName:@"save" stringValue:@"true"];
        [iq addChild:query];
        [[self xmppStream] sendElement:iq];
    }
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self goOnline];
}

- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource
{
    return @"ios";
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    
}
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    
}

#pragma mark - XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    
}

@end
