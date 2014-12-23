//
//  ServerManager.h
//  sculz
//
//  Created by veddislabs on 23/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject <NSURLConnectionDataDelegate>

+(id) sharedManager;

-(void)getNearbySchools:(float)lat :(float)lon : (NSString *)token;

@end
