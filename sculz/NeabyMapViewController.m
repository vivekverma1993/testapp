//
//  NeabyMapViewController.m
//  sculz
//
//  Created by veddislabs on 27/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "NeabyMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "dataModel.h"
#import "school.h"
#import "StarRatingView.h"

@interface NeabyMapViewController ()
@property (nonatomic) GMSMapView *mapView;

@end

@implementation NeabyMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar  setBarTintColor:[UIColor redColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    self.navigationItem.title = @"Mapview";

    double lon = 77.2274863;
    double lat = 28.5723769;
    
    self.mapView = [[GMSMapView alloc] init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:13];
    self.mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64) camera:camera];
    self.mapView.settings.zoomGestures = YES;
    self.mapView.settings.scrollGestures = YES;
    
//    self.mapView.layer.cornerRadius = 5.0f;
//    self.mapView.layer.borderWidth = 2.0f;
//    self.mapView.layer.borderColor = [UIColor blackColor].CGColor;
    
    for(int i=0; i<[[[dataModel sharedManager] nearbySchools] count]; i++){
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:@"schoolMarker"];
        marker.position = CLLocationCoordinate2DMake(((school*)[[[dataModel sharedManager] nearbySchools] objectAtIndex:i]).latitude, ((school*)[[[dataModel sharedManager] nearbySchools] objectAtIndex:i]).longitude);
        marker.title = ((school*)[[[dataModel sharedManager] nearbySchools] objectAtIndex:i]).name;
        marker.snippet = ((school*)[[[dataModel sharedManager] nearbySchools] objectAtIndex:i]).address;
        marker.map = self.mapView;
    }
    //UIView *mapOverlay =[[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-30, CGRectGetHeight(self.view.frame)-200)];
    
    
    //[self.mapView addSubview:mapOverlay];
    [self.view insertSubview:self.mapView atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
