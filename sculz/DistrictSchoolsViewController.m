//
//  DistrictSchoolsViewController.m
//  sculz
//
//  Created by veddislabs on 28/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import "DistrictSchoolsViewController.h"
#import "ServerManager.h"
#import "dataModel.h"
#import "SingleDistrictViewController.h"

@interface DistrictSchoolsViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *names;
@property (strong) UIActivityIndicatorView *mySpin;


@end

@implementation DistrictSchoolsViewController


-(void)schoolsReady{
    [self.mySpin stopAnimating];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.navigationBar  setBarTintColor:[UIColor redColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    self.navigationItem.title = @"Districts";

    
    self.mySpin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.mySpin setColor:[UIColor blackColor]];
    self.mySpin.center = (CGPoint){self.view.frame.size.width/2,self.view.frame.size.height/2};
    self.mySpin.hidesWhenStopped = YES;
    [self.view addSubview:self.mySpin];
    
    self.names = @[@"New Delhi", @"Central", @"North", @"East", @"West A", @"West B", @"South"];
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,64, 320, self.view.bounds.size.height-64)];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(schoolsReady)
                                                 name:@"schoolsReady"
                                               object:nil];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *simpleTableIdentifier = [NSString stringWithFormat:@"district%ld",(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell== nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
        
        UILabel *district = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 55)];
        district.text = self.names[indexPath.row];
        district.textAlignment = NSTextAlignmentCenter;
        district.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:22];
        district.backgroundColor = [UIColor whiteColor];
        [cell addSubview:district];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.mySpin startAnimating];
    [[dataModel sharedManager] setCurrentZone:self.names[indexPath.row]];
    //dispatch_async(dispatch_get_main_queue(), ^{
        [[ServerManager sharedManager] getDistrictSchools:28.5723769 :77.2274863 :[NSString stringWithFormat:@"%d",((user*)[[dataModel sharedManager] presentUser]).idU]: self.names[indexPath.row]];
        
    //});
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self.navigationController performSegueWithIdentifier:@"district" sender:nil];
    SingleDistrictViewController *destViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"singleDist"];
    
    destViewController.zone = [[dataModel sharedManager] currentZone];
    
    [self.navigationController showViewController:destViewController sender:nil];
  
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"hiii!!!!");
    if ([[segue identifier] isEqualToString:@"district"])
    {
        // Get reference to the destination view controller
        SingleDistrictViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        vc.zone = @"north";
    }
    
}

@end
