//
//  NearbySchoolViewController.m
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "NearbySchoolViewController.h"
#import "dataModel.h"
#import "RDVTabBarController.h"
#import "RDVTabBarItem.h"
#import "school.h"
#import "schoolViewController.h"

@interface NearbySchoolViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) UITextField *searchBar;
@end

@implementation NearbySchoolViewController


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
    
    //[[self rdv_tabBarItem] setBadgeValue:@"3"];
    
    if (self.rdv_tabBarController.tabBar.translucent) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0,
                                               0,
                                               CGRectGetHeight(self.rdv_tabBarController.tabBar.frame),
                                               0);
        
        self.tableView.contentInset = insets;
        self.tableView.scrollIndicatorInsets = insets;
    }

    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, 320, self.view.bounds.size.height)];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
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
            
            UIView *searchview = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 30)];
            searchview.backgroundColor = [UIColor whiteColor];
            
            
            self.searchBar = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, 295, 30)];
            
            self.searchBar.userInteractionEnabled = true;
            [self.searchBar setFont:[UIFont boldSystemFontOfSize:14]];
            self.searchBar.placeholder = @"Search Nearby Schools...";
            //searchBar.leftViewMode = UITextFieldViewModeAlways;
            self.searchBar.delegate = self;
            
            UIView *mapView = [[UIView alloc] initWithFrame:CGRectMake(5, 45, 310, 70)];
            mapView.backgroundColor = [UIColor whiteColor];
            
            UIImageView *mapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 150, 70)];
            mapImageView.image = [UIImage imageNamed:@"map"];
            
            [mapView addSubview:mapImageView];
            [searchview addSubview:self.searchBar];
            [cell addSubview:searchview];
            [cell addSubview:mapView];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"result%ld",indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
            
            UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 110)];
            bview.backgroundColor = [UIColor whiteColor];
                                     
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 250, 20)];
            name.text = ((school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1]).name;
            name.textColor = [UIColor redColor];
            name.font = [UIFont fontWithName:@"Arial" size:12];
            
            UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 250, 20)];
            address.text = ((school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1]).address;
            address.textColor = [UIColor blackColor];
            address.font = [UIFont fontWithName:@"Arial" size:10];
            
            UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 5, 30, 20)];
            rateLabel.text = [NSString stringWithFormat:@"%@",((school *)[[[dataModel sharedManager] nearbySchools] objectAtIndex:indexPath.row-1]).rating];
            rateLabel.textAlignment= NSTextAlignmentCenter;
            rateLabel.backgroundColor = [UIColor orangeColor];
            rateLabel.textColor = [UIColor whiteColor];
            rateLabel.font = [UIFont fontWithName:@"Arial-Bold" size:12];
        
            
            [bview addSubview:name];
            [bview addSubview:address];
            [bview addSubview:rateLabel];
            [cell addSubview:bview];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    }
    
}





@end
