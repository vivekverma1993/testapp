//
//  SideBarViewController.m
//  sculz
//
//  Created by vivek verma on 12/02/15.
//  Copyright (c) 2015 self. All rights reserved.
//


#define screenWidth [[UIScreen mainScreen] bounds].size.width
#define screenHeight [[UIScreen mainScreen] bounds].size.height

#import "SideBarViewController.h"


@interface SideBarViewController ()
@property (nonatomic, strong) NSArray *identifiers;
@property (nonatomic, strong) NSArray *cellTitles;
@property (nonatomic, strong) NSArray *cellImages;
@property (nonatomic) UIView *cellSeperator;
@property (nonatomic) UITableView *tableView;

@end

@implementation SideBarViewController

#pragma mark create  and send Google Analytics tracking request



-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"view appered");
    
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"disableMain" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"view disappeared");
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"enableMain" object:nil];
}


- (void) explore{
    NSLog(@"exploration begins");
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.cellSeperator = [[UIView alloc] initWithFrame:CGRectMake(10, 39, 240 , 1)];
    self.cellSeperator.backgroundColor = [UIColor colorWithRed:0.929 green:0.929 blue:0.929 alpha:1];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sidebar" ofType:@"plist"];
    
    
    // Load the file content and read the data into arrays
    NSDictionary *cellData = [[NSDictionary alloc] initWithContentsOfFile:path];
    _identifiers = [cellData objectForKey:@"Identifiers"];
    _cellTitles = [cellData objectForKey:@"cellTiltes"];
    _cellImages = [cellData objectForKey:@"cellImages"];
    
    
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height-44)];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
    
    //    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 6, 120, 32)];
    //
    //    titleView.image = [UIImage imageNamed:@"Realopoly_TopBar"];
    //
    //    [self.navigationController.navigationBar addSubview:titleView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    tableView.scrollEnabled = NO;
    return [self.identifiers count] + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        NSString *profileCell = @"profile";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:profileCell];
        
        float mainImageTopPadding = 27.5;
        float mainImageLeftPadding = 20;
        float mainImageHeight = 100;
        float mainImageWidth = 100;
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:profileCell];
        }
        
        UIImageView *profileImageView=[[UIImageView alloc] initWithFrame:CGRectMake(mainImageLeftPadding, mainImageTopPadding , mainImageWidth, mainImageHeight)];
        
        profileImageView.image = [UIImage imageNamed:@""];
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height /2;
        profileImageView.layer.masksToBounds = YES;
        profileImageView.layer.borderWidth = 5;
        profileImageView.layer.borderColor = [[UIColor whiteColor]CGColor];
        
        UILabel *profileName = [[UILabel alloc] initWithFrame:CGRectMake(mainImageLeftPadding + mainImageWidth + 10 , mainImageTopPadding + 30  , mainImageWidth+50, 20)];
        
        profileName.text = @"vivek verma";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell addSubview:profileName];
        
        [cell addSubview:profileImageView];
        
        
        
        cell.backgroundColor=[UIColor colorWithRed:61/255.0f green:201/255.0f blue:120/255.0f alpha:1.0f];
        return cell;
    }
    else{
        NSString *CellIdentifier = [self.identifiers objectAtIndex:indexPath.row - 1];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        //        UIImageView *newImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        
        //        UIImage *image = [UIImage imageNamed:[self.cellImages objectAtIndex:indexPath.row - 1]];
        cell.imageView.image = [UIImage imageNamed:[self.cellImages objectAtIndex:indexPath.row - 1]];
        //        [cell.imageView setFrame:CGRectMake(10, 10, 10, 10)];
        //        [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
        cell.textLabel.text = [self.cellTitles objectAtIndex:indexPath.row - 1];
        
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        //        [cell addSubview:self.cellSeperator];
        
        
        return cell;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.row == 0){
        return 155;
    }
    else{
        return 50;
    }
}



- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
//    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
//        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
//        
//        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
//            
//            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
//            [navController setViewControllers: @[dvc] animated: NO ];
//            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
//        };
//        
//    }
    
}


#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}


@end