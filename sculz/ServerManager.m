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
#import "schoolViewController.h"
#import "LoginViewController.h"
#import "SingleDistrictViewController.h"
#import "DistrictSchoolsViewController.h"

@implementation ServerManager


+(id) sharedManager {
    static ServerManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)isLoggedIn:(NSString *)username :(NSString *)password{
    NSString *URLString = [NSString stringWithFormat:@"http://localhost:8888/login?username=%@&password=%@", username, password];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    //Making the MutableURLrequest & configuring it (POST) to add more headers/data to it.
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:URL];
    [postRequest setTimeoutInterval:60];
    [postRequest setHTTPMethod:@"POST"];
    
    //Creating the URL session and corresponding configuration
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *myResponse = (NSHTTPURLResponse*) response;
        NSLog(@"my status code is %ld" , (long)myResponse.statusCode);
        if (myResponse.statusCode == 200)
        {
            NSDictionary  *item = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSString *loggedIn = item[@"isLoggedIn"];
            
            if([loggedIn boolValue]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *idU = item[@"userDetails"][@"id"];
                    NSString *name = item[@"userDetails"][@"name"];
                    NSArray *keys = [NSArray arrayWithObjects:@"id",@"name", nil];
                    NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",idU],[NSString stringWithFormat:@"%@",name], nil];
                    NSDictionary *loginDesc = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginSuccessful" object:LoginViewController.class userInfo:loginDesc];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSArray *keys = [NSArray arrayWithObjects:@"reason", nil];
                    NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"Incorrect Password!!"], nil];
                    NSDictionary *loginDesc = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"loginUnSuccessful" object:LoginViewController.class userInfo:loginDesc];
                });
            }
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *keys = [NSArray arrayWithObjects:@"reason", nil];
                NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"username doesn't exists!!"], nil];
                NSDictionary *loginDesc = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginUnSuccessful" object:LoginViewController.class userInfo:loginDesc];
            });
        }
    }] resume];
    
    sleep(2);

}

-(void)getNearbySchools:(float)lat :(float)lon : (NSString *)userId{
    NSString *urlRequest = [NSString stringWithFormat:@"http://localhost:8888/nearby?lat=%f&lon=%f&user=%@",lat,lon,userId];
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
                        
                        
                        
//                        NSLog(@"id of current school is %d",(int)[item[@"results"][i][@"id"] integerValue]);
                        tempSchool = [[school alloc] initWithIdS:(int)[item[@"results"][i][@"id"] integerValue]
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
                                     distanceFromCurrentLocation:[item[@"results"][i][@"distance"] floatValue]
                                                isRatedByCurrent:[item[@"results"][i][@"isRatedByUser"] boolValue]
                                               currentUserRating:item[@"results"][i][@"userRating"]];
    
                        [arr addObject:(school*)tempSchool];
                        i++;
                    }
                    [[dataModel sharedManager] setNearbySchools:(NSMutableArray *)arr];
//                    NSLog(@"total number of schools is %ld",(long)[[[dataModel sharedManager] nearbySchools] count]);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"propertiesFetched" object:LoginViewController.class];
                }
            }
        }
    }] resume];
    sleep(2);

}

-(void)getDistrictSchools:(float)lat :(float)lon : (NSString *)userId :(NSString *)district{
    NSString *urlRequest = [NSString stringWithFormat:@"http://localhost:8888/zoneschools?lat=%f&lon=%f&user=%@&zone=%@",lat,lon,userId,district];
    urlRequest = [urlRequest stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
                        
                        
                        
//                        NSLog(@"id of current school is %d",(int)[item[@"results"][i][@"id"] integerValue]);
                        tempSchool = [[school alloc] initWithIdS:(int)[item[@"results"][i][@"id"] integerValue]
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
                                     distanceFromCurrentLocation:[item[@"results"][i][@"distance"] floatValue]
                                                isRatedByCurrent:[item[@"results"][i][@"isRatedByUser"] boolValue]
                                               currentUserRating:item[@"results"][i][@"userRating"]];
                        
                        [arr addObject:(school*)tempSchool];
                        i++;
                    }
                    [[dataModel sharedManager] setDistrictSchools:(NSMutableArray *)arr];
                    NSLog(@"total number of schools is %ld",(long)[[[dataModel sharedManager] districtSchools] count]);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"schoolsReady" object:DistrictSchoolsViewController.class];
                }
            }
        }
    }] resume];
    sleep(2);
}


-(void)submitRating:(int)rating :(int)schoolId : (int)userId{
    NSString *URLString = [NSString stringWithFormat:@"http://localhost:8888/post?ID=%d&rating=%d&user=%d",schoolId ,rating,userId];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    //Making the MutableURLrequest & configuring it (POST) to add more headers/data to it.
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:URL];
    [postRequest setTimeoutInterval:60];
    [postRequest setHTTPMethod:@"POST"];
    
    //Creating the URL session and corresponding configuration
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
//    NSString *post = [[NSString alloc] initWithFormat:@"ID=%d&rating=%d",schoolId ,rating];
//    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [postRequest setHTTPBody:postData];
    
    [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *myResponse = (NSHTTPURLResponse*) response;
        NSLog(@"my status code is %ld" , (long)myResponse.statusCode);
        if (myResponse.statusCode == 200)
        {
            NSDictionary  *item = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
            [format setNumberStyle:NSNumberFormatterDecimalStyle];
            [format setRoundingMode:NSNumberFormatterRoundHalfUp];
            [format setMaximumFractionDigits:1];
            [format setMinimumFractionDigits:1];
            
            NSString *newRating = [format stringFromNumber:[NSNumber numberWithFloat:[item[@"result"][@"newRating"] floatValue]]];
            int totalRatings = (int)[item[@"result"][@"total_ratings"] integerValue];
            NSString *userRating = item[@"result"][@"currUserRating"];
            
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *keys = [NSArray arrayWithObjects:@"newRating",@"totalRatings",@"userRating", nil];
                NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",newRating],[NSString stringWithFormat:@"%d",totalRatings],[NSString stringWithFormat:@"%@",userRating], nil];
                NSDictionary *ratingDesc = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ratingSubmitted" object:schoolViewController.class userInfo:ratingDesc];
            });
        }
    }] resume];
    
    sleep(2);

}


-(void)changeRating:(int)rating :(int)oldRating :(int)schoolId : (int)userId{
    NSString *URLString = [NSString stringWithFormat:@"http://localhost:8888/change?ID=%d&rating=%d&oldRating=%d&user=%d",schoolId ,rating,oldRating,userId];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    //Making the MutableURLrequest & configuring it (POST) to add more headers/data to it.
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:URL];
    [postRequest setTimeoutInterval:60];
    [postRequest setHTTPMethod:@"POST"];
    
    //Creating the URL session and corresponding configuration
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    //    NSString *post = [[NSString alloc] initWithFormat:@"ID=%d&rating=%d",schoolId ,rating];
    //    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    //    [postRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //    [postRequest setHTTPBody:postData];
    
    [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *myResponse = (NSHTTPURLResponse*) response;
        NSLog(@"my status code is %ld" , (long)myResponse.statusCode);
        if (myResponse.statusCode == 200)
        {
            NSDictionary  *item = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
            [format setNumberStyle:NSNumberFormatterDecimalStyle];
            [format setRoundingMode:NSNumberFormatterRoundHalfUp];
            [format setMaximumFractionDigits:1];
            [format setMinimumFractionDigits:1];
            
            NSString *newRating = [format stringFromNumber:[NSNumber numberWithFloat:[item[@"result"][@"newRating"] floatValue]]];
            NSString *userRating = item[@"result"][@"currUserRating"];
            
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *keys = [NSArray arrayWithObjects:@"newRating",@"userRating", nil];
                NSArray *objects = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",newRating],[NSString stringWithFormat:@"%@",userRating], nil];
                NSDictionary *ratingDesc = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ratingChanged" object:schoolViewController.class userInfo:ratingDesc];
            });
        }
    }] resume];
    
    sleep(2);

}


-(void)saveSchool:(NSString *)name :(NSString *)address :(NSString *)contact :(NSString *)email{
    NSString *URLString = [NSString stringWithFormat:@"http://localhost:8888/saveSchool?name=%@&address=%@&contact=%@&email=%@",name ,address,contact,email];
    
    NSString* urlTextEscaped = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *URL = [NSURL URLWithString:urlTextEscaped];
    
    //Making the MutableURLrequest & configuring it (POST) to add more headers/data to it.
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:URL];
    [postRequest setTimeoutInterval:60];
    [postRequest setHTTPMethod:@"POST"];
    
    //Creating the URL session and corresponding configuration
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    
    [[session dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *myResponse = (NSHTTPURLResponse*) response;
        NSLog(@"my status code is %ld" , (long)myResponse.statusCode);
        if (myResponse.statusCode == 200)
        {
            NSDictionary  *item = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"%@",item[@"message"]);
        }
    }] resume];
    
}

@end
