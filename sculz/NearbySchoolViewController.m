//
//  NearbySchoolViewController.m
//  sculz
//
//  Created by veddislabs on 20/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "NearbySchoolViewController.h"
#import "dataModel.h"

@interface NearbySchoolViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) UITextField *searchBar;
@end

@implementation NearbySchoolViewController



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
    //return [[[dataModel sharedManager] nearbySchools] count];
    return 10;
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
                                     
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 20)];
            name.text = @"Abcd school";
            name.textColor = [UIColor redColor];
            name.font = [UIFont fontWithName:@"Arial" size:16];
            
            UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 150, 20)];
            address.text = @"Civil Lines, Delhi";
            address.textColor = [UIColor blackColor];
            address.font = [UIFont fontWithName:@"Arial" size:16];
            
            UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 5, 30, 20)];
            rateLabel.text = @"3.9";
            rateLabel.textAlignment= NSTextAlignmentCenter;
            rateLabel.backgroundColor = [UIColor orangeColor];
            rateLabel.textColor = [UIColor whiteColor];
            rateLabel.font = [UIFont fontWithName:@"Arial-Bold" size:16];
        
            
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




@end
