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

@interface NearbySchoolViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) UITextField *searchBar;

@property (nonatomic) UIView *callMenu;
@property (nonatomic) UIView *mapMenu;
@property (nonatomic) UIView *directionMenu;
@property (nonatomic) UIView *reviewMenu;

@property (nonatomic) UILabel *callMenuTopBar;
@property (nonatomic) UIButton *callMenuCancelButton;
@property (nonatomic) UILabel *callMenuPhoneLabel;
@property (nonatomic) UIButton *callMenuCallButton;

@property (nonatomic) UILabel *mapMenuTopBar;
@property (nonatomic) UIButton *mapMenuCancelButton;
@property (nonatomic) GMSMapView *mapView;

@property (nonatomic) UILabel *directionMenuTopBar;
@property (nonatomic) UIButton *directionMenuCancelButton;
@property (nonatomic) GMSMapView *directionMapView;

@property (nonatomic) UILabel *reviewMenuTopBar;
@property (nonatomic) UIButton *reviewMenuCancelButton;
@property (nonatomic) GMSMapView *reviewMapView;






@end

@implementation NearbySchoolViewController


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
    
    self.callMenuPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, screenHeight*0.5-200, screenWidth-100, 100)];
    self.callMenuPhoneLabel.text = @"+91112375689";
    self.callMenuPhoneLabel.font = [UIFont fontWithName:@"Futura-Medium" size:24];
    self.callMenuPhoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.callMenu addSubview:self.callMenuPhoneLabel];
    
    self.callMenuCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.callMenuCallButton.backgroundColor = [UIColor colorWithRed:187/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f];
    [self.callMenuCallButton addTarget:self action:@selector(removeCallView) forControlEvents:UIControlEventTouchUpInside];
    [self.callMenuCallButton setFrame:CGRectMake(100, screenHeight*0.5-50, screenWidth-200, 50)];
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
    
    self.mapView = [[GMSMapView alloc] init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:13];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) camera:camera];
    self.mapView.settings.zoomGestures = YES;
    self.mapView.settings.scrollGestures = YES;
    

    
    
    
    self.mapMenu.layer.borderWidth = 5.0f;
    self.mapMenu.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:240/255.0f alpha:1.0f];
    [self.mapMenu addSubview:self.mapView];
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
   
    self.mapView = [[GMSMapView alloc] init];
    GMSCameraPosition *camera2 = [GMSCameraPosition cameraWithLatitude:lat2
                                                            longitude:lon2
                                                                 zoom:13];
    self.directionMapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) camera:camera2];
    self.directionMapView.settings.zoomGestures = YES;
    self.directionMapView.settings.scrollGestures = YES;

    self.directionMenu.layer.borderWidth = 5.0f;
    self.directionMenu.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:240/255.0f alpha:1.0f];
    [self.directionMenu addSubview:self.directionMapView];
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
    
    self.reviewMenu.layer.borderWidth = 5.0f;
    self.reviewMenu.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:240/255.0f alpha:1.0f];
    [self.reviewMenu addSubview:self.reviewMenuTopBar];


    //reviews menu end
    
    [self.view addSubview:self.callMenu];
    [self.view addSubview:self.mapMenu];
    [self.view addSubview:self.directionMenu];
    [self.view addSubview:self.reviewMenu];
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
        
    }];
}

-(void)removeDirectionMapView{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.directionMenu.frame  = CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)removeReviewMenu{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.reviewMenu.frame  = CGRectMake(0, screenHeight-44, screenWidth, screenHeight-44);
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void)callAction{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.callMenu.frame  = CGRectMake(0, 64, screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)mapviewAction{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mapMenu.frame  = CGRectMake(0, 64, screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        double lon = 77.2274863;
        double lat = 28.5723769;
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:@"schoolMarker"];
        marker.position = CLLocationCoordinate2DMake(lat,lon);
        marker.title = @"hehe";
        marker.snippet = @"rofl";
        marker.map = self.mapView;
        
        
    }];
}

-(void)directionsAction{
    [UIView animateWithDuration:.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.directionMenu.frame  = CGRectMake(0, 64, screenWidth,screenHeight);
    } completion:^(BOOL finished) {
        double lon = 77.2274863;
        double lat = 28.5723769;
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:@"schoolMarker"];
        marker.position = CLLocationCoordinate2DMake(lat,lon);
        marker.title = @"hehe";
        marker.snippet = @"rofl";
        marker.map = self.directionMapView;
        
        
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
    [self.searchBar becomeFirstResponder];
}

// This method is called once we complete editing
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"Text field ended editing");
}

// This method enables or disables the processing of return key
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self.searchBar resignFirstResponder];
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
            [callButton setImage:[UIImage imageNamed:@"iphone2"] forState:UIControlStateNormal];
            [callButton addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
            
            [callButton setFrame:CGRectMake(35, 70, 35, 35)];
            callButton.layer.cornerRadius = 17.5f;
            callButton.backgroundColor = btnBackColor;
            
            UIButton *mapView =  [UIButton buttonWithType:UIButtonTypeCustom];
            [mapView setImage:[UIImage imageNamed:@"mapview"] forState:UIControlStateNormal];
            [mapView addTarget:self action:@selector(mapviewAction) forControlEvents:UIControlEventTouchUpInside];
            
            [mapView setFrame:CGRectMake(103, 70, 35, 35)];
            mapView.layer.cornerRadius = 17.5f;
            mapView.backgroundColor = btnBackColor;
            
            
            UIButton *direction =  [UIButton buttonWithType:UIButtonTypeCustom];
            [direction setImage:[UIImage imageNamed:@"directions"] forState:UIControlStateNormal];
            [direction addTarget:self action:@selector(directionsAction) forControlEvents:UIControlEventTouchUpInside];
            
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
            [bview addSubview:mapView];
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
