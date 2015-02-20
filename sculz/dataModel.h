//
//  dataModel.h
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "school.h"
#import "user.h"
#import  <FacebookSDK/FacebookSDK.h>

@interface dataModel : NSObject

@property(nonatomic) school *presentSchool;
@property(nonatomic) int presentSchoolIndex;
@property(nonatomic) user *presentUser;
@property(nonatomic) NSMutableArray *nearbySchools;
@property(strong, nonatomic) UIWindow *window;
@property(nonatomic) NSMutableArray *districtSchools;
@property(nonatomic) NSString *currentZone;
@property(nonatomic) NSString *profileIdOfuser;

+(id) sharedManager;

@end
