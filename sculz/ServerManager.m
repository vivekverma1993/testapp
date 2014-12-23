//
//  ServerManager.m
//  sculz
//
//  Created by veddislabs on 23/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "ServerManager.h"
#import "dataModel.h"
#import "school.h"

@implementation ServerManager


+(id) sharedManager {
    static ServerManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)getNearbySchools:(float)lat :(float)lon : (NSString *)token{
    NSString *urlRequest = [NSString stringWithFormat:@"http://localhost:8888/nearby?lat=%f&lon=%f",lat,lon];
    NSURL *URL = [NSURL URLWithString:urlRequest];
    
    //Making the MutableURLrequest & configuring it (GET) to add more headers to it.
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:URL];
    [getRequest setTimeoutInterval:60];
    [getRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    [getRequest setHTTPMethod:@"GET"];
    [getRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    //Creating a session and corresponding configuration
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    [[session dataTaskWithRequest:getRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error)
            NSLog(@"Error occured %@",[error description]);
        else
        {
            
            NSDictionary  *item = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if (!item)
            {
                NSLog(@"\n\nFollowing Error occured while getting names : %@\n\n",error.description);
            }
            else
            {
                int i=0;
                if(item){
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    while(i < [item[@"results"] count])
                    {
                        school *tempSchool;
                        float value = [item[@"results"][i][@"ratings"] floatValue];
                        
                        NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
                        [format setNumberStyle:NSNumberFormatterDecimalStyle];
                        [format setRoundingMode:NSNumberFormatterRoundHalfUp];
                        [format setMaximumFractionDigits:1];
                        [format setMinimumFractionDigits:1];
                        
                        
                        NSLog(@"id of current school is %@",[format stringFromNumber:[NSNumber numberWithFloat:value]]);
                        tempSchool = [[school alloc] initWithIdS:(int)item[@"results"][i][@"id"]
                                                            name:item[@"results"][i][@"name"]
                                                         address:item[@"results"][i][@"address"]
                                                         contact:item[@"results"][i][@"contact"]
                                                        latitude:[item[@"results"][i][@"latitude"] floatValue]
                                                       longitude:[item[@"results"][i][@"longitude"] floatValue]
                                                          rating:[format stringFromNumber:[NSNumber numberWithFloat:value]]
                                                  numberOfRaters:(int)item[@"results"][i][@"total_ratings"]
                                                 numberOfReviews:0
                                                         review1:[NSString stringWithFormat:@"it is best"]
                                                         review2:[NSString stringWithFormat:@"great school"]
                                     distanceFromCurrentLocation:[item[@"results"][i][@"distance"] floatValue]];
    
                        [arr addObject:(school*)tempSchool];
                        i++;
                    }
                    [[dataModel sharedManager] setNearbySchools:(NSMutableArray *)arr];
                    NSLog(@"total number of friends is %ld",(long)[[[dataModel sharedManager] nearbySchools] count]);
                }
            }
        }
    }] resume];
    sleep(2);

}

@end
