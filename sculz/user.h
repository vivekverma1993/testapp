//
//  user.h
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface user : NSObject


@property(nonatomic) int idU;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *address;
@property(nonatomic) NSString *contact;
@property(nonatomic) NSString *role;

- (instancetype)initWithIdU:(int)idU
                       name:(NSString*)name
                    address:(NSString*)address
                    contact:(NSString*)contact
                       role:(NSString*)role;


@end
