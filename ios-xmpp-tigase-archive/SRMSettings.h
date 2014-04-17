//
//  SRMSettings.h
//  ios-xmpp-tigase-archive
//
//  Created by Mingyang Song on 4/17/14.
//  Copyright (c) 2014 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const xmppUsername;
extern NSString *const xmppassword;
extern NSString *const xmppServer;

@interface SRMSettings : NSObject

+(NSString *)getCurrentTime;

@end
