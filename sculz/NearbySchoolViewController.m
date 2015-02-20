//
//  NearbySchoolViewController.m
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

#define leftMargin ([[UIScreen mainScreen] bounds].size.width)*0.1


#import <GoogleMaps/GoogleMaps.h>
#import "NearbySchoolViewController.h"
#import "dataModel.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "school.h"
#import "schoolViewController.h"
#import "UIButton+additions.h"
#import "sculz-Swift.h"
#import "ServerManager.h"



@interface NearbySchoolViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) UITextField *searchBar;
@property (nonatomic) UIView *callMenu;
@property (nonatomic) UIView *mapMenu;
@property (nonatomic) UIView *directionMenu;
@property (nonatomic) UIView *reviewMenu;
@property (nonatomic) UILabel *callMenuTopBar;
@property (nonatomic) UIButton *callMenuCancelButton;
@property (nonatomic) UILabel *callMenuSchoolNameLabel;
@property (nonatomic) UILabel *callMenuSchoolAddressLabel;
@property (nonatomic) UILabel *callMenuPhoneLabel;
@property (nonatomic) UIButton *callMenuCallButton;
@property (nonatomic) UILabel *mapMenuTopBar;
@property (nonatomic) UIButton *mapMenuCancelButton;
@property (nonatomic) GMSMapView *mapView_old;
@property (nonatomic) UILabel *directionMenuTopBar;
@property (nonatomic) UIButton *directionMenuCancelButton;
@property (nonatomic) GMSMapView *directionMapView_old;
@property (nonatomic) UILabel *reviewMenuTopBar;
@property (nonatomic) UIButton *reviewMenuCancelButton;
@property (nonatomic) UIView *reviewBtnBox;
@property (nonatomic) UIButton *writeReview;
@property (nonatomic) UITextView *reviewBox;
@property (nonatomic) UIButton *submitReview;
@property (nonatomic) UIButton *cancelReview;
@property (nonatomic) UIButton *sidebarButton;
@property (nonatomic) UIView *sideBar;
@property (nonatomic) BOOL isSideBarPresent;
@property (nonatomic) FBProfilePictureView *sideBarImageView;
@property (nonatomic) UIButton *editProfile;
@property (nonatomic) UIButton *addSchool;
@property (nonatomic) UIButton *signOut;
@property (nonatomic) UIView *addSchoolMenu;
@property (nonatomic) UIButton *addSchoolMenuCancelButton;
@property (nonatomic) UITextField *nameOfSchool;
@property (nonatomic) UITextField *addressOfSchool;
@property (nonatomic) UITextField *emailOfSchool;
@property (nonatomic) UITextField *contactOfSchool;
@property (nonatomic) UIButton *submitSchoolDetails;



@end

@implementation NearbySchoolViewController{
    GMSMapView *mapView;
    GMSMapView *directionMapView;
}


-(void)moveTextViewUp{
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reviewBtnBox.frame  = CGRectMake(-screenWidth, screenHeight-380, 2*screenWidth, 100);
        
    } completion:^(BOOL finished) {
        
    }];

}

-(void)moveTextViewDown{
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reviewBtnBox.frame  = CGRectMake(-screenWidth, screenHeight-260, 2*screenWidth, 100);
        
    } completion:^(BOOL finished) {
        
    }];
    
}


#pragma mark text view delegate methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self moveTextViewUp];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"textViewDidBeginEditing:");
    //textView.backgroundColor = [UIColor greenColor];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    NSLog(@"textViewShouldEndEditing:");
    [self moveTextViewDown];
    //textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"textViewDidEndEditing:");
}


#pragma mark add school

-(void)clearSchoolData{
    [self.nameOfSchool setText:@""];
    [self.addressOfSchool setText:@""];
    [self.contactOfSchool setText:@""];
    [self.emailOfSchool setText:@""];
}

-(void)addScl{
    [[ServerManager sharedManager] saveSchool:self.nameOfSchool.text :self.addressOfSchool.text :self.contactOfSchool.text :self.emailOfSchool.text];
    [self removeAddSchoolView];
    [self clearSchoolData];
}

#pragma mark side bar menu methods

-(void)removeAddSchoolView{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.addSchoolMenu.frame  = CGRectMake(0, screenHeight-44, screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showAddSchool{
    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.sideBar.frame  = CGRectMake(-screenWidth+100, 64, screenWidth-100, screenHeight-64);
        
    } completion:^(BOOL finished) {
        self.isSideBarPresent = NO;
        [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.addSchoolMenu.frame  = CGRectMake(0, 64, screenWidth,screenHeight);
        } completion:^(BOOL finished) {
            
        }];
    }];
}


-(void)manageSideBar{
    if(self.isSideBarPresent){
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.sideBar.frame  = CGRectMake(-screenWidth+100, 64, screenWidth-100, screenHeight-64);
            
        } completion:^(BOOL finished) {
            self.isSideBarPresent = NO;
        }];
    }
    else{
        [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.sideBar.frame  = CGRectMake(0, 64, screenWidth-100, screenHeight-64);
            
        } completion:^(BOOL finished) {
            self.isSideBarPresent = YES;
        }];
    }

}

-(void)makeAddSchoolMenu{
    self.addSchoolMenu = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44)];
    self.addSchoolMenu.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:240/255.0f alpha:1.0f];
    
    self.addSchoolMenuCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addSchoolMenuCancelButton setImage:[UIImage imageNamed:@"black_close"] forState:UIControlStateNormal];
    [self.addSchoolMenuCancelButton addTarget:self action:@selector(removeAddSchoolView) forControlEvents:UIControlEventTouchUpInside];
    [self.addSchoolMenuCancelButton setFrame:CGRectMake(screenWidth-40, 10, 30, 30)];
    [self.addSchoolMenu addSubview:self.addSchoolMenuCancelButton];
    
    self.nameOfSchool = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, screenWidth-40, 40)];
    self.nameOfSchool.userInteractionEnabled = true;
    [self.nameOfSchool setFont:[UIFont boldSystemFontOfSize:14]];
    self.nameOfSchool.placeholder = @"  Name";
    self.nameOfSchool.delegate = self;
    self.nameOfSchool.backgroundColor = [UIColor whiteColor];
    self.nameOfSchool.layer.borderWidth = 0.5f;
    
    self.addressOfSchool = [[UITextField alloc] initWithFrame:CGRectMake(20, 90, screenWidth-40, 40)];
    self.addressOfSchool.userInteractionEnabled = true;
    [self.addressOfSchool setFont:[UIFont boldSystemFontOfSize:14]];
    self.addressOfSchool.placeholder = @"  Address";
    self.addressOfSchool.delegate = self;
    self.addressOfSchool.backgroundColor = [UIColor whiteColor];
    self.addressOfSchool.layer.borderWidth = 0.5f;
    
    self.contactOfSchool = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, screenWidth-40, 40)];
    self.contactOfSchool.userInteractionEnabled = true;
    [self.contactOfSchool setFont:[UIFont boldSystemFontOfSize:14]];
    self.contactOfSchool.placeholder = @"  Contact Number";
    self.contactOfSchool.delegate = self;
    self.contactOfSchool.backgroundColor = [UIColor whiteColor];
    self.contactOfSchool.layer.borderWidth = 0.5f;
    
    self.emailOfSchool = [[UITextField alloc] initWithFrame:CGRectMake(20, 190, screenWidth-40, 40)];
    self.emailOfSchool.userInteractionEnabled = true;
    [self.emailOfSchool setFont:[UIFont boldSystemFontOfSize:14]];
    self.emailOfSchool.placeholder = @"  email";
    self.emailOfSchool.delegate = self;
    self.emailOfSchool.backgroundColor = [UIColor whiteColor];
    self.emailOfSchool.layer.borderWidth = 0.5f;
    
    
    self.submitSchoolDetails =  [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitSchoolDetails.backgroundColor = [UIColor colorWithRed:187/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    [self.submitSchoolDetails setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitSchoolDetails setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.submitSchoolDetails.layer.borderWidth = 0.8f;
    [self.submitSchoolDetails addTarget:self action:@selector(addScl) forControlEvents:UIControlEventTouchUpInside];
    [self.submitSchoolDetails setFrame:CGRectMake(50, 250, screenWidth-100, 50)];
    
    [self.addSchoolMenu addSubview:self.submitSchoolDetails];
    [self.addSchoolMenu addSubview:self.nameOfSchool];
    [self.addSchoolMenu addSubview:self.addressOfSchool];
    [self.addSchoolMenu addSubview:self.contactOfSchool];
    [self.addSchoolMenu addSubview:self.emailOfSchool];
    [self.view addSubview:self.addSchoolMenu];
    
}

-(void)makeSideBar{
    self.sideBar = [[UIView alloc] initWithFrame:CGRectMake(-screenWidth+100, 64, screenWidth-100, screenHeight-64)];
    self.sideBar.backgroundColor  = [UIColor colorWithRed:255/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    
    self.sideBarImageView = [[FBProfilePictureView alloc] initWithProfileID:[[dataModel sharedManager] profileIdOfuser] pictureCropping:FBProfilePictureCroppingOriginal];
    self.sideBarImageView.frame = CGRectMake(0, 0, screenWidth-100, screenWidth-100);
    [self.sideBar addSubview:self.sideBarImageView];
    
    
    
    
    self.addSchool =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addSchool setTitle:@"Add School" forState:UIControlStateNormal];
    [self.addSchool setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.addSchool addTarget:self action:@selector(showAddSchool) forControlEvents:UIControlEventTouchUpInside];
    [self.addSchool setFrame:CGRectMake(0, screenWidth-100, screenWidth-100, 30)];
    
    UIImageView *buttonImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 20)];
    buttonImage.image = [UIImage imageNamed:@"add"];
    [self.addSchool addSubview:buttonImage];
    [self.sideBar addSubview:self.addSchool];

    [self.view addSubview:self.sideBar];
}


#pragma mark Make Menus

-(void)makeMenus{
    
    // call menu start
    self.callMenu = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44)];
    self.mapMenu = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44)];
    self.directionMenu = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44)];
    self.reviewMenu = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44)];
    
    self.callMenuTopBar = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, screenWidth-100, 50)];
    self.callMenuTopBar.text = @"Call";
    self.callMenuTopBar.textAlignment = NSTextAlignmentCenter;
    self.callMenuTopBar.font = [UIFont fontWithName:@"Futura-Medium" size:19];
    
    self.callMenuCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.callMenuCancelButton setImage:[UIImage imageNamed:@"black_close"] forState:UIControlStateNormal];
    [self.callMenuCancelButton addTarget:self action:@selector(removeCallView) forControlEvents:UIControlEventTouchUpInside];
    [self.callMenuCancelButton setFrame:CGRectMake(screenWidth-40, 10, 30, 30)];
    [self.callMenu addSubview:self.callMenuCancelButton];
    
    self.callMenuSchoolNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, screenHeight*0.5-250, screenWidth-100, 100)];
    self.callMenuSchoolNameLabel.text = @"name";
    self.callMenuSchoolNameLabel.numberOfLines = 0;
    self.callMenuSchoolNameLabel.font = [UIFont fontWithName:@"Futura-Medium" size:20];
    self.callMenuSchoolNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.callMenu addSubview:self.callMenuSchoolNameLabel];

    self.callMenuSchoolAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, screenHeight*0.5-150, screenWidth-100, 100)];
    self.callMenuSchoolAddressLabel.text = @"address";
    self.callMenuSchoolAddressLabel.font = [UIFont fontWithName:@"Futura-Medium" size:20];
    self.callMenuSchoolAddressLabel.textAlignment = NSTextAlignmentCenter;
    [self.callMenu addSubview:self.callMenuSchoolAddressLabel];

    
    self.callMenuPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, screenHeight*0.5-50, screenWidth-100, 100)];
    self.callMenuPhoneLabel.text = @"phone";
    self.callMenuPhoneLabel.font = [UIFont fontWithName:@"Futura-Medium" size:24];
    self.callMenuPhoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.callMenu addSubview:self.callMenuPhoneLabel];
    
    self.callMenuCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callMenuCallButton.backgroundColor = [UIColor colorWithRed:187/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    [self.callMenuCallButton addTarget:self action:@selector(removeCallView) forControlEvents:UIControlEventTouchUpInside];
    [self.callMenuCallButton setFrame:CGRectMake(100, screenHeight*0.5+50, screenWidth-200, 50)];
    [self.callMenuCallButton setTitle:@"Call" forState:UIControlStateNormal];
    [self.callMenuCallButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.callMenuCallButton.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:24];
    [self.callMenu addSubview:self.callMenuCallButton];
    
    
    self.callMenu.layer.borderWidth = 5.0f;
    self.callMenu.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:240/255.0f alpha:1.0f];
    [self.callMenu addSubview:self.callMenuTopBar];
    
    // call menu end
    
    // map menu start
    self.mapMenuTopBar = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, screenWidth-100, 50)];
    self.mapMenuTopBar.text = @"Map";
    self.mapMenuTopBar.textAlignment = NSTextAlignmentCenter;
    self.mapMenuTopBar.font = [UIFont fontWithName:@"Futura-Medium" size:19];
    
    self.mapMenuCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mapMenuCancelButton setImage:[UIImage imageNamed:@"black_close"] forState:UIControlStateNormal];
    [self.mapMenuCancelButton addTarget:self action:@selector(removeMapView) forControlEvents:UIControlEventTouchUpInside];
    [self.mapMenuCancelButton setFrame:CGRectMake(screenWidth-40, 10, 30, 30)];
    [self.mapMenu addSubview:self.mapMenuCancelButton];
    
    double lon = 77.2274863;
    double lat = 28.5723769;
    
    mapView = [[GMSMapView alloc] init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                zoom:13];
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) camera:camera];
    mapView.settings.zoomGestures = YES;
    mapView.settings.scrollGestures = YES;
    self.mapMenu.layer.borderWidth = 5.0f;
    self.mapMenu.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:240/255.0f alpha:1.0f];
    [self.mapMenu addSubview:mapView];
    [self.mapMenu addSubview:self.mapMenuTopBar];
    // map menu end
    
    
    //directions menu start
    self.directionMenuTopBar = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, screenWidth-100, 50)];
    self.directionMenuTopBar.text = @"Directions";
    self.directionMenuTopBar.textAlignment = NSTextAlignmentCenter;
    self.directionMenuTopBar.font = [UIFont fontWithName:@"Futura-Medium" size:19];
    
    self.directionMenuCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.directionMenuCancelButton setImage:[UIImage imageNamed:@"black_close"] forState:UIControlStateNormal];
    [self.directionMenuCancelButton addTarget:self action:@selector(removeDirectionMapView) forControlEvents:UIControlEventTouchUpInside];
    [self.directionMenuCancelButton setFrame:CGRectMake(screenWidth-40, 10, 30, 30)];
    [self.directionMenu addSubview:self.directionMenuCancelButton];
    
    double lon2 = 77.2274863;
    double lat2 = 28.5723769;
   
    directionMapView = [[GMSMapView alloc] init];
    GMSCameraPosition *camera2 = [GMSCameraPosition cameraWithLatitude:lat2
                                                            longitude:lon2
                                                                 zoom:14];
    directionMapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-155) camera:camera2];
    directionMapView.settings.zoomGestures = YES;
    directionMapView.settings.scrollGestures = YES;

    self.directionMenu.layer.borderWidth = 5.0f;
    self.directionMenu.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:240/255.0f alpha:1.0f];
    [self.directionMenu addSubview:directionMapView];
    [self.directionMenu addSubview:self.directionMenuTopBar];

    //directions menu end
    
    //reviews menu start
    self.reviewMenuTopBar = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, screenWidth-100, 50)];
    self.reviewMenuTopBar.text = @"Reviews";
    self.reviewMenuTopBar.textAlignment = NSTextAlignmentCenter;
    self.reviewMenuTopBar.font = [UIFont fontWithName:@"Futura-Medium" size:19];
    
    self.reviewMenuCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reviewMenuCancelButton setImage:[UIImage imageNamed:@"black_close"] forState:UIControlStateNormal];
    [self.reviewMenuCancelButton addTarget:self action:@selector(removeReviewMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.reviewMenuCancelButton setFrame:CGRectMake(screenWidth-40, 10, 30, 30)];
    [self.reviewMenu addSubview:self.reviewMenuCancelButton];
    
    
    self.reviewBtnBox = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-260, 2*screenWidth, 180)];
    
    self.writeReview =  [UIButton buttonWithType:UIButtonTypeCustom];
    self.writeReview.backgroundColor = [UIColor colorWithRed:187/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    [self.writeReview setTitle:@"Write review" forState:UIControlStateNormal];
    [self.writeReview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.writeReview.layer.borderWidth = 0.8f;
    [self.writeReview addTarget:self action:@selector(writeNewReview) forControlEvents:UIControlEventTouchUpInside];
    [self.writeReview setFrame:CGRectMake(40, 80, screenWidth-80, 50)];
    [self.reviewBtnBox addSubview:self.writeReview];
    
    self.reviewMenu.layer.borderWidth = 5.0f;
    self.reviewMenu.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:240/255.0f alpha:1.0f];
    [self.reviewMenu addSubview:self.reviewMenuTopBar];
    
    self.reviewBox = [[UITextView alloc] initWithFrame:CGRectMake(screenWidth+20, 0, screenWidth-40, 80)];
    self.reviewBox.returnKeyType = UIReturnKeyDone;
    [self.reviewBtnBox addSubview:self.reviewBox];
    self.reviewBox.layer.borderWidth = 0.5f;
    
    self.reviewBox.delegate = self;

    
    self.submitReview =  [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitReview.backgroundColor = [UIColor colorWithRed:187/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    [self.submitReview setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitReview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.submitReview.layer.borderWidth = 0.8f;
    [self.submitReview addTarget:self action:@selector(submitReviewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.submitReview setFrame:CGRectMake(screenWidth+20, 90, (screenWidth-40)*0.5-10, 50)];
    [self.reviewBtnBox addSubview:self.submitReview];
    
    [self.reviewMenu addSubview:self.reviewBtnBox];
    
    self.cancelReview =  [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelReview.backgroundColor = [UIColor colorWithRed:187/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    [self.cancelReview setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelReview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancelReview.layer.borderWidth = 0.8f;
    [self.cancelReview addTarget:self action:@selector(cancelReviewAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelReview setFrame:CGRectMake(screenWidth + (screenWidth-40)*0.5+30, 90, (screenWidth-40)*0.5-10, 50)];
    [self.reviewBtnBox addSubview:self.cancelReview];
    
    [self.reviewMenu addSubview:self.reviewBtnBox];
    
    [self.view addSubview:self.callMenu];
    [self.view addSubview:self.mapMenu];
    [self.view addSubview:self.directionMenu];
    [self.view addSubview:self.reviewMenu];
}

-(void)cancelReviewAction{
    NSLog(@"cancel review");
    [UIView animateWithDuration:.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reviewBtnBox.frame  = CGRectMake(0, screenHeight-260, 2*screenWidth, 180);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)submitReviewAction{
    [UIView animateWithDuration:.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reviewBtnBox.frame  = CGRectMake(0, screenHeight-260, 2*screenWidth, 180);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)writeNewReview{
    [UIView animateWithDuration:.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reviewBtnBox.frame  = CGRectMake(-screenWidth, screenHeight-260, 2*screenWidth, 180);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)closeTextViewForReview{
    [UIView animateWithDuration:.6 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reviewBtnBox.frame  = CGRectMake(0, screenHeight-260, 2*screenWidth, 180);
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void)removeCallView{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.callMenu.frame  = CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)removeMapView{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mapMenu.frame  = CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44);
        
    } completion:^(BOOL finished) {
        [mapView clear];
    }];
}

-(void)removeDirectionMapView{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.directionMenu.frame  = CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44);
        
    } completion:^(BOOL finished) {
        [directionMapView clear];
    }];
}

-(void)removeReviewMenu{
    
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reviewMenu.frame  = CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44);
        
    } completion:^(BOOL finished) {
        [self closeTextViewForReview];
    }];
}


-(void)callAction:(UIButton *)sender{
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.callMenu.frame  = CGRectMake(0, 64, screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        self.callMenuSchoolNameLabel.text = [NSString stringWithFormat:@"%@", sender.school.name];
        self.callMenuSchoolAddressLabel.text = [NSString stringWithFormat:@"%@", sender.school.address];
        self.callMenuPhoneLabel.text= [NSString stringWithFormat:@"%@", sender.school.contact];
    }];
    NSLog(@"here");
    
}

-(void)mapviewAction:(UIButton *)sender{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mapMenu.frame  = CGRectMake(0, 64, screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        double lon = sender.school.longitude;
        double lat = sender.school.latitude;
        NSLog(@"lat and lon are %f, %f",lat,lon);
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                longitude:lon
                                                                     zoom:14];
        [mapView setCamera:camera];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:@"schoolmarker"];
        marker.position = CLLocationCoordinate2DMake(lat,lon);
        marker.title = [NSString stringWithFormat:@"%@",sender.school.name];
        marker.snippet = [NSString stringWithFormat:@"%@",sender.school.address];
        marker.map = mapView;
    }];
}

-(void)directionsAction:(UIButton *)sender{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.directionMenu.frame  = CGRectMake(0, 64, screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        double lon = sender.school.longitude;
        double lat = sender.school.latitude;
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(lat,lon);
        marker.title = sender.school.name;
        marker.snippet = sender.school.address;
        marker.map = directionMapView;
        
        
        double ulon = 77.2274863;
        double ulat = 28.5723769;
        
        GMSMarker *user = [[GMSMarker alloc] init];
        user.position = CLLocationCoordinate2DMake(ulat,ulon);
        user.title = @"start";
        user.snippet = @"rofl";
        user.map = directionMapView;
        
        
        GoogleDataProvider *dataProvider = [[GoogleDataProvider alloc] init];
        
        [dataProvider fetchDirectionsFrom:marker.position to:user.position completion:^(NSString * optionalRoute) {
            GMSPath *path =  [GMSPath pathFromEncodedPath:optionalRoute];
            GMSPolyline *rectangle = [GMSPolyline polylineWithPath:path];
            rectangle.strokeWidth = 2.f;
            rectangle.map = directionMapView;
            
            GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithPath:path];
            
            GMSCameraUpdate *fitin = [GMSCameraUpdate fitBounds:bounds];
            [directionMapView animateWithCameraUpdate:fitin];
        }];
    }];

}
-(void)reviewAction{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reviewMenu.frame  = CGRectMake(0, 64, screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        
    }];

}



-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Nearby";
    }
    return self;
}

// This method is called once we click inside the textField
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"Text field did begin editing");
    [textField becomeFirstResponder];
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)settt{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.sidebarButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sidebarButton setImage:[UIImage imageNamed:@"side_menu"] forState:UIControlStateNormal];
    [self.sidebarButton addTarget:self action:@selector(manageSideBar) forControlEvents:UIControlEventTouchUpInside];
    [self.sidebarButton setFrame:CGRectMake(0, 6, 32, 32)];
    
    [self.navigationController.navigationBar addSubview:self.sidebarButton];
    

    

    [[self rdv_tabBarItem] setTitle:@"Nearby"]; 
    
    [self.navigationController.navigationBar  setBarTintColor:[UIColor redColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    self.navigationItem.title = @"Nearby Schools";
    
    if (self.rdv_tabBarController.tabBar.translucent) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0,
                                               0,
                                               CGRectGetHeight(self.rdv_tabBarController.tabBar.frame),
                                               0);
        
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }
    


    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
    [self makeMenus];
    [self makeSideBar];
    [self makeAddSchoolMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[dataModel sharedManager] nearbySchools] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"maincell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
            
            UIView *searchview = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 40)];
            searchview.backgroundColor = [UIColor whiteColor];
            
            
            self.searchBar = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 295, 30)];
            
            self.searchBar.userInteractionEnabled = true;
            [self.searchBar setFont:[UIFont boldSystemFontOfSize:14]];
            self.searchBar.placeholder = @"Search Nearby Schools...";
            //searchBar.leftViewMode = UITextFieldViewModeAlways;
            self.searchBar.delegate = self;
            
            
            [searchview addSubview:self.searchBar];
            [cell addSubview:searchview];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"result%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
            
            UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 110)];
            bview.backgroundColor = [UIColor whiteColor];
                                     
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 250, 20)];
            name.text = ((school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1]).name;
            name.textColor = [UIColor redColor];

            name.font = [UIFont fontWithName:@"Futura-Medium" size:12];
            
            UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 250, 20)];
            address.text = ((school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1]).address;
            address.textColor = [UIColor blackColor];
            address.font = [UIFont fontWithName:@"Futura-Medium" size:10];
            
            UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 5, 30, 20)];
            rateLabel.text = [NSString stringWithFormat:@"%@",((school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1]).rating];
            rateLabel.textAlignment= NSTextAlignmentCenter;
            rateLabel.backgroundColor = [UIColor orangeColor];
            rateLabel.textColor = [UIColor whiteColor];
            rateLabel.font = [UIFont fontWithName:@"Futura-Medium" size:12];
            
            UIColor * btnBackColor = [UIColor colorWithRed:187/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
            
            UIButton *callButton =  [UIButton buttonWithType:UIButtonTypeCustom];
            callButton.school = (school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1];
            [callButton setImage:[UIImage imageNamed:@"iphone2"] forState:UIControlStateNormal];
            [callButton addTarget:self action:@selector(callAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [callButton setFrame:CGRectMake(35, 70, 35, 35)];
            callButton.layer.cornerRadius = 17.5f;
            callButton.backgroundColor = btnBackColor;
            
            UIButton *mapViewM =  [UIButton buttonWithType:UIButtonTypeCustom];
            mapViewM.school = (school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1];
            [mapViewM setImage:[UIImage imageNamed:@"mapview"] forState:UIControlStateNormal];
            [mapViewM addTarget:self action:@selector(mapviewAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [mapViewM setFrame:CGRectMake(103, 70, 35, 35)];
            mapViewM.layer.cornerRadius = 17.5f;
            mapViewM.backgroundColor = btnBackColor;
            
            
            UIButton *direction =  [UIButton buttonWithType:UIButtonTypeCustom];
            direction.school = (school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1];
            [direction setImage:[UIImage imageNamed:@"directions"] forState:UIControlStateNormal];
            [direction addTarget:self action:@selector(directionsAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [direction setFrame:CGRectMake(171, 70, 35, 35)];
            direction.layer.cornerRadius = 17.5f;
            direction.backgroundColor = btnBackColor;
            
            UIButton *reviews =  [UIButton buttonWithType:UIButtonTypeCustom];
            [reviews setImage:[UIImage imageNamed:@"pen"] forState:UIControlStateNormal];
            [reviews addTarget:self action:@selector(reviewAction) forControlEvents:UIControlEventTouchUpInside];
        
            [reviews setFrame:CGRectMake(239, 70, 35, 35)];
            reviews.layer.cornerRadius = 17.5f;
            reviews.backgroundColor = btnBackColor;



        
            
            [bview addSubview:name];
            [bview addSubview:address];
            [bview addSubview:rateLabel];
            [bview addSubview:callButton];
            [bview addSubview:mapViewM];
            [bview addSubview:direction];
            [bview addSubview:reviews];
            [cell addSubview:bview];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 50;
    }
    else{
        return 120;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row!=0){
        [[dataModel sharedManager] setPresentSchool:((school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1])];
        [[dataModel sharedManager] setPresentSchoolIndex:(int)indexPath.row-1];
        NSLog(@"current user property id is %@",((school *)[[dataModel sharedManager] presentSchool]).name);
    
        
       // MyNewViewController *myNewVC = [[MyNewViewController alloc] init];
        
        // do any setup you need for myNewVC
        
        //[self presentModalViewController:myNewVC animated:YES];
        
        [self performSegueWithIdentifier:@"schoolDetail" sender:self];
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"hey!!!!");
    if ([[segue identifier] isEqualToString:@"schoolDetail"])
    {
        // Get reference to the destination view controller
        schoolViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.school = [[dataModel sharedManager] presentSchool];
        vc.schoolIndex = [[dataModel sharedManager] presentSchoolIndex];
        vc.type = 0;
    }
    
}





@end
