//
//  SingleDistrictViewController.m
//  sculz
//
//  Created by veddislabs on 28/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "SingleDistrictViewController.h"
#import "dataModel.h"
#import "ServerManager.h"
#import "schoolViewController.h"
#import "school.h"

//hey i m back

@interface SingleDistrictViewController ()
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic) UITextField *searchBar;

@end

@implementation SingleDistrictViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.zone);
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[dataModel sharedManager] districtSchools] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"result%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
            
            UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 110)];
            bview.backgroundColor = [UIColor whiteColor];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 250, 20)];
            name.text = ((school *)[[[dataModel sharedManager] districtSchools] objectAtIndex:indexPath.row]).name;
            name.textColor = [UIColor redColor];
            
            name.font = [UIFont fontWithName:@"Futura-Medium" size:12];
            
            UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(5, 25, 250, 20)];
            address.text = ((school *)[[[dataModel sharedManager] districtSchools] objectAtIndex:indexPath.row]).address;
            address.textColor = [UIColor blackColor];
            address.font = [UIFont fontWithName:@"Futura-Medium" size:10];
            
            UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(275, 5, 30, 20)];
            rateLabel.text = [NSString stringWithFormat:@"%@",((school *)[[[dataModel sharedManager] districtSchools] objectAtIndex:indexPath.row]).rating];
            rateLabel.textAlignment= NSTextAlignmentCenter;
            rateLabel.backgroundColor = [UIColor orangeColor];
            rateLabel.textColor = [UIColor whiteColor];
            rateLabel.font = [UIFont fontWithName:@"Futura-Medium" size:12];
            
            
            [bview addSubview:name];
            [bview addSubview:address];
            [bview addSubview:rateLabel];
            [cell addSubview:bview];
            
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[dataModel sharedManager] setPresentSchool:((school *)[[[dataModel sharedManager] districtSchools] objectAtIndex:indexPath.row])];
    [[dataModel sharedManager] setPresentSchoolIndex:(int)indexPath.row];
    
     schoolViewController *destViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"school"];
    
    destViewController.school = [[dataModel sharedManager] presentSchool];
    destViewController.schoolIndex = [[dataModel sharedManager] presentSchoolIndex];
    destViewController.type =1;

    [self.navigationController showViewController:destViewController sender:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
