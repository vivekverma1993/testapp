//
//  AppDelegate.m
//  sculz
//
//  Created by veddislabs on 18/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "dataModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    [FBLoginView class];
    [GMSServices provideAPIKey:@"AIzaSyBCbd_T_EbPYmalEP8P-PEzY0hXFMF34m8"];

    LoginViewController *loginViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"login"];
    
    
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor whiteColor];
//    
//    [self.window setRootViewController:loginViewController];
//    [self.window makeKeyAndVisible];

    ([[dataModel sharedManager] window]).backgroundColor =  [UIColor whiteColor];
    [[[dataModel sharedManager] window] setRootViewController:loginViewController];
    [[[dataModel sharedManager] window] makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandledByFacebook = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    BOOL wasHandledByGoogle = [GPPURLHandler handleURL:url
                                     sourceApplication:sourceApplication
                                            annotation:annotation];

    
    // You can add your app-specific url handling code here if needed
    if(wasHandledByFacebook){
        return wasHandledByFacebook;
    }
    else if(wasHandledByGoogle){
        return wasHandledByGoogle;
    }
    else{
        return NO;
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
