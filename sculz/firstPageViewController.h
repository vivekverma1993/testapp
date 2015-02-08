//
//  firstPageViewController.h
//  sculz
//
//  Created by vivek verma on 04/02/15.
//  Copyright (c) 2015 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h> 
#import <GooglePlus/GooglePlus.h>


@class GPPSignInButton;
@interface firstPageViewController : UIViewController <FBLoginViewDelegate, GPPSignInDelegate, UITextFieldDelegate,CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
}
@property (retain, nonatomic) GPPSignInButton *signInButton;
@property (strong, nonatomic) UIViewController *viewController;

@end


