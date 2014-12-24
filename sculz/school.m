//
//  school.m
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "school.h"

@implementation school

- (instancetype)initWithIdS:(int)idS
                       name:(NSString*)name
                    address:(NSString*)address
                    contact:(NSString*)contact
                   latitude:(double)latitude
                  longitude:(double)longitude
                     rating:(NSString*)rating
             numberOfRaters:(int)numberOfRaters
            numberOfReviews:(int)numberOfReviews
                    review1:(NSString*)review1
                    review2:(NSString*)review2
distanceFromCurrentLocation:(float)distanceFromCurrentLocation
           isRatedByCurrent:(BOOL) isRatedByCurrent
          currentUserRating:(NSString*)currentUserRating{
    self = [super init];
    if (self) {
        _idS = idS;
        _name = name;
        _address = address;
        _contact = contact;
        _latitude = latitude;
        _longitude = longitude;
        _rating = rating;
        _numberOfRaters = numberOfRaters;
        _numberOfReviews = numberOfReviews;
        _review1 = review1;
        _review2 = review2;
        _distanceFromCurrentLocation = distanceFromCurrentLocation;
        _isRatedByCurrent = isRatedByCurrent;
        _currentUserRating = currentUserRating;
    }
    return self;
}

@end
