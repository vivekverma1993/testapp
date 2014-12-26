//
//  schoolViewController.m
//  sculz
//
//  Created by veddislabs on 19/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//


#import "schoolViewController.h"
#import "StarRatingView.h"
#import "FXBlurView/FXBlurView.h"
#import "ServerManager.h"
#import "dataModel.h"

//#import "constants.h"

@interface schoolViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *downButtonView;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) UIButton *bookmarkButton;
@property (nonatomic, strong) UIButton *beenhereButton;
@property (nonatomic, strong) UIButton *ratingButton;
@property (nonatomic, strong) UIAlertController *alertController;
@property (nonatomic, strong) FXBlurView *fullBlurView;
@property (nonatomic, strong) UIView *ratingView;
@property (nonatomic, strong) StarRatingView* ratingStarsView;
@property (nonatomic, strong) UIButton *ratingCancelButton;
@property (nonatomic, strong) UIButton *ratingSubmitButton;
// attributes


@end


@implementation schoolViewController


-(void)changeRatingButton{
    [self.ratingButton removeFromSuperview];
    self.ratingButton = nil;
    self.ratingButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ratingButton setFrame:CGRectMake(265, 5, 30, 30)];
    self.ratingButton.layer.cornerRadius = 15.0f;
    
    self.ratingButton.backgroundColor= [UIColor orangeColor];
    [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ratingButton setTitle:[NSString stringWithFormat:@"%@",self.school.currentUserRating] forState:UIControlStateNormal];
    [self.ratingButton addTarget:self action:@selector(rateAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.downButtonView addSubview:self.ratingButton];
    
}

-(void)ratingSubmitted:(NSNotification *)ratingInfo{
    NSDictionary *dict = [ratingInfo userInfo];
    NSString *newRating = [dict objectForKey:@"newRating"];
    int totalRating = (int)[[dict objectForKey:@"totalRatings"] integerValue];
    NSString *rating = [dict objectForKey:@"userRating"];
    [self.school setIsRatedByCurrent:YES];
    [self.school setCurrentUserRating:rating];
    [self.school setRating:newRating];
    [self.school setNumberOfRaters:totalRating];
    [[[dataModel sharedManager] nearbySchools] setObject:self.school atIndexedSubscript:self.schoolIndex];
    [self changeRatingButton];
    [self.fullBlurView removeFromSuperview];
    [self.tableView reloadData];

}

-(void)cancelRating{
    [self.fullBlurView removeFromSuperview];
}

-(void)submitRating{
    int rating = self.ratingStarsView.rating;
    rating = (rating*5)/100;
    NSLog(@"%d",rating);
    [[ServerManager sharedManager] submitRating:rating :self.school.idS :0];
}


#pragma mark List of actions


-(void)makeAlert{
    self.alertController = [UIAlertController
                                          alertControllerWithTitle:@""
                            message:[NSString stringWithFormat:@"%@",self.school.contact]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];

    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Call", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   // make call code here and test with a iphone not a ios simiulator
                               }];
    
    [self.alertController addAction:cancelAction];
    [self.alertController addAction:okAction];
}


-(void)callAction{
    //open a alert View with a message to call that school
    
    [self presentViewController:self.alertController animated:YES completion:nil];
   
    
}

-(void)bookmarkAction{
    self.bookmarkButton.backgroundColor = [UIColor redColor];
    
    // write a request here to save the current school
    // check whether it is already saved or not.
}

-(void)beenHereAction{
    // write a request to save this school as the place where the user has studied
    
}
-(void)rateAction{
    // call them in view did load just add remove here
    
    self.fullBlurView = [[FXBlurView alloc] initWithFrame:self.view.bounds];
    self.fullBlurView.alpha=0.95;
    self.fullBlurView.tintColor = [UIColor blackColor];
    [self.fullBlurView setDynamic:YES];
    
    UIColor * btnColor = [UIColor colorWithRed:255/255.0f green:248/255.0f blue:104/255.0f alpha:1.0f];
    
    self.ratingStarsView = [[StarRatingView alloc]initWithFrame:CGRectMake(60, 30, 180, 30) andRating:0 withLabel:NO animated:YES];
//    self.ratingStarsView.r
    
    self.ratingCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    self.ratingCancelButton.backgroundColor = btnColor;
    [self.ratingCancelButton setFrame:CGRectMake(45 , 90 , 100, 40)];
    [self.ratingCancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.ratingCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.ratingCancelButton.layer.cornerRadius = 5.0f;
    [self.ratingCancelButton addTarget:self action:@selector(cancelRating) forControlEvents:UIControlEventTouchUpInside];
    
    self.ratingSubmitButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    self.ratingSubmitButton.backgroundColor = btnColor;
    [self.ratingSubmitButton setFrame:CGRectMake(160 , 90 , 100, 40)];
    [self.ratingSubmitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.ratingSubmitButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.ratingSubmitButton.layer.cornerRadius = 5.0f;
    [self.ratingSubmitButton addTarget:self action:@selector(submitRating) forControlEvents:UIControlEventTouchUpInside];

    
    self.ratingView = [[UIView alloc] initWithFrame:CGRectMake(10, (self.view.bounds.size.height/2)-50, 300 , 150)];
    self.ratingView.backgroundColor = [UIColor colorWithRed:190/255.0f green:98/255.0f blue:126/255.0f alpha:1.0f];
    self.ratingView.layer.cornerRadius = 5.0f;
    self.ratingView.alpha = 1.0;
    
    [self.ratingView addSubview:self.ratingStarsView];
    [self.ratingView addSubview:self.ratingCancelButton];
    [self.ratingView addSubview:self.ratingSubmitButton];
    [self.fullBlurView addSubview:self.ratingView];
    [self.view addSubview:self.fullBlurView];

}


-(UIView *)constructDownButtonView:(float) height{
    self.downButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, height-50 , 320, 50)];
    
    self.callButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.callButton setImage:[UIImage imageNamed:@"iphone1"] forState:UIControlStateNormal];
    [self.callButton addTarget:self action:@selector(callAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.callButton setFrame:CGRectMake(25, 5, 30, 30)];
    self.callButton.layer.cornerRadius = 15.0f;
    self.callButton.backgroundColor = [UIColor greenColor];
    
    
    self.bookmarkButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bookmarkButton setImage:[UIImage imageNamed:@"book2"] forState:UIControlStateNormal];
    [self.bookmarkButton addTarget:self action:@selector(bookmarkAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bookmarkButton setFrame:CGRectMake(105, 5, 30, 30)];
    self.bookmarkButton.layer.cornerRadius = 15.0f;
    self.bookmarkButton.backgroundColor = [UIColor grayColor];

    
    self.beenhereButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.beenhereButton setImage:[UIImage imageNamed:@"studiedHere"] forState:UIControlStateNormal];
    [self.beenhereButton addTarget:self action:@selector(beenHereAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.beenhereButton setFrame:CGRectMake(185, 5, 30, 30)];
    self.beenhereButton.layer.cornerRadius = 15.0f;
    self.beenhereButton.backgroundColor = [UIColor grayColor];
    
    self.ratingButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [self.ratingButton setFrame:CGRectMake(265, 5, 30, 30)];
    self.ratingButton.layer.cornerRadius = 15.0f;
    
    if(self.school.isRatedByCurrent){
        self.ratingButton.backgroundColor= [UIColor orangeColor];
        [self.ratingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.ratingButton setTitle:[NSString stringWithFormat:@"%@",self.school.currentUserRating] forState:UIControlStateNormal];
    }
    else{
        [self.ratingButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        self.ratingButton.backgroundColor = [UIColor grayColor];
    }
    [self.ratingButton addTarget:self action:@selector(rateAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.downButtonView addSubview:self.callButton];
    [self.downButtonView addSubview:self.bookmarkButton];
    [self.downButtonView addSubview:self.beenhereButton];
    [self.downButtonView addSubview:self.ratingButton];
    
    return self.downButtonView;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, 320, self.view.bounds.size.height-64)];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];
    
    [self makeAlert];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ratingSubmitted:)
                                                 name:@"ratingSubmitted"
                                               object:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0){
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"maincell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell== nil){
            
            float cellHeight = (self.view.bounds.size.height-110)/2;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, cellHeight)];
            imageView.image = [UIImage imageNamed:@"scl.jpg"];
            
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 250, 20)];
            nameLabel.text = self.school.name;
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
            
            
            UILabel *rateLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 15, 30, 25)];
            rateLabel.text = self.school.rating;
            rateLabel.textAlignment= NSTextAlignmentCenter;
            rateLabel.backgroundColor = [UIColor orangeColor];
            rateLabel.textColor = [UIColor whiteColor];
            rateLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
            
            FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, cellHeight)];
            blurView.alpha=0.95;
            blurView.tintColor = [UIColor blackColor];
            [blurView setDynamic:NO];
            [imageView addSubview:blurView];
            [imageView addSubview:nameLabel];
            [imageView addSubview:rateLabel];
            
            [cell addSubview:imageView];
            [cell addSubview:self.downButtonView];
            [cell addSubview:[self constructDownButtonView:cellHeight]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row==1){
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"addresscell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell== nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            UILabel *addressHeading = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 270, 15)];
            addressHeading.font= [UIFont fontWithName:@"Arial-BoldMT" size:10];
            addressHeading.text = [NSString stringWithFormat:@"ADDRESS"];
            
            UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 20, 270, 15)];
            addressLabel.numberOfLines = 0;
            addressLabel.font= [UIFont fontWithName:@"Arial" size:10];
            addressLabel.textColor = [UIColor grayColor];
            addressLabel.text = [NSString stringWithFormat:@"%@",self.school.address];
            
            
            [cell addSubview:addressHeading];
            [cell addSubview:addressLabel];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row==2){
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"review1"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell== nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row==3){
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"review2"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell== nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row==4){
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"allReviews"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell== nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row==5){
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"writeReview"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell== nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@""];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell== nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return (self.view.bounds.size.height-110)/2;
    }
    else if(indexPath.row==1 || indexPath.row == 2 || indexPath.row == 3){
        return (self.view.bounds.size.height-110)/4;
    }
    else{
        return (self.view.bounds.size.height-110)/8;
    }
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
