//
//  user.m
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "user.h"

@implementation user

- (instancetype)initWithIdU:(int)idU
                       name:(NSString*)name
                    address:(NSString*)address
                    contact:(NSString*)contact{
    self = [super init];
    if (self) {
        _idU = idU;
        _name = name;
        _address = address;
        _contact = contact;
    }
    return self;
}

@end