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

-(void)getNearbySchools:(float)lat :(float)lon : (NSString *)userId;

-(void)getDistrictSchools:(float)lat :(float)lon : (NSString *)userId :(NSString *)district;

-(void)submitRating:(int)rating :(int)schoolId : (int)userId;

-(void)changeRating:(int)rating :(int)oldRating :(int)schoolId : (int)userId;

-(void)isLoggedIn:(NSString *)username :(NSString *)password;

-(void)saveSchool:(NSString *)name :(NSString *)address :(NSString *)contact :(NSString *)email;

@end
