//
//  dataModel.h
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "school.h"

@interface dataModel : NSObject

@property(nonatomic) school *presentSchool;
@property(nonatomic) NSMutableArray *nearbySchools;

+(id) sharedManager;

@end
