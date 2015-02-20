//
//  UIButton+additions.m
//  sculz
//
//  Created by vivek verma on 10/02/15.
//  Copyright (c) 2015 self. All rights reserved.
//

#import <objc/runtime.h>
#import "UIButton+additions.h"
static const void *schoolKey = &schoolKey;

@implementation UIButton (additions)

-(void)setSchool:(school *)school{
    objc_setAssociatedObject(self, schoolKey, school, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(school *)school{
    return (school*)objc_getAssociatedObject(self, schoolKey);
}

@end
