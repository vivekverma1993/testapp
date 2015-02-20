//
//  UIButton+additions.h
//  sculz
//
//  Created by vivek verma on 10/02/15.
//  Copyright (c) 2015 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "school.h"

@interface UIButton (additions)
@property (nonatomic, retain) school *school;
-(void)setSchool:(school *)school;
-(school *)school;
@end
