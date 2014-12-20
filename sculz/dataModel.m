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
    });
    return sharedMyManager;
}

@end
