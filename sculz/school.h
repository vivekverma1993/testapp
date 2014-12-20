//
//  school.h
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface school : NSObject

@property(nonatomic) int idS;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *address;
@property(nonatomic) NSString *contact;
@property(nonatomic) double latitude;
@property(nonatomic) double longitude;
@property(nonatomic) float rating;
@property(nonatomic) int numberOfRaters;
@property(nonatomic) int numberOfReviews;
@property(nonatomic) NSString *review1;
@property(nonatomic) NSString *review2;

- (instancetype)initWithIdS:(int)idS
                       name:(NSString*)name
                    address:(NSString*)address
                    contact:(NSString*)contact
                   latitude:(double)latitude
                  longitude:(double)longitude
                     rating:(float)rating
             numberOfRaters:(int)numberOfRaters
             numberOfReviews:(int)numberOfReviews
                    review1:(NSString*)review1
                    review2:(NSString*)review2;


@end
