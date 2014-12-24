//
//  dataModel.m
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "dataModel.h"

@implementation dataModel

+(id) sharedManager {
    static dataModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.presentSchool = [[school alloc] init];
        sharedMyManager.nearbySchools = [[NSMutableArray alloc] init];
        sharedMyManager.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        sharedMyManager.presentSchoolIndex = -1;
    });
    return sharedMyManager;
}

@end
