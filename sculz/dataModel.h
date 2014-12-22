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

@interface dataModel : NSObject

@property(nonatomic) school *presentSchool;
@property(nonatomic) NSMutableArray *nearbySchools;
@property (strong, nonatomic) UIWindow *window;


+(id) sharedManager;

@end
