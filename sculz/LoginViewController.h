//
//  LoginViewController.h
//  sculz
//
//  Created by veddislabs on 22/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIViewController *viewController;


@end
