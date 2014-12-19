//
//  schoolViewController.m
//  sculz
//
//  Created by veddislabs on 19/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//


#import "schoolViewController.h"
//#import "constants.h"

@interface schoolViewController ()
@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UIView *downButtonView;
@property (nonatomic, strong) UIButton *callButton;
@property (nonatomic, strong) UIButton *bookmarkButton;
@property (nonatomic, strong) UIButton *beenhereButton;
@property (nonatomic, strong) UIButton *ratingButton;

@end


@implementation schoolViewController



#pragma mark List of actions

-(void)callAction{

}

-(void)bookmarkAction{

}

-(void)beenHereAction{
    
}
-(void)rateAction{

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
    [self.ratingButton setImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
    [self.ratingButton addTarget:self action:@selector(rateAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.ratingButton setFrame:CGRectMake(265, 5, 30, 30)];
    self.ratingButton.layer.cornerRadius = 15.0f;
    self.ratingButton.backgroundColor = [UIColor grayColor];
    
    
    [self.downButtonView addSubview:self.callButton];
    [self.downButtonView addSubview:self.bookmarkButton];
    [self.downButtonView addSubview:self.beenhereButton];
    [self.downButtonView addSubview:self.ratingButton];
    
    return self.downButtonView;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:2/255.0f green:18/255.0f blue:13/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    self.tableView =[[UITableView alloc] initWithFrame:CGRectMake(0,0, 320, self.view.bounds.size.height-64)];
    
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:self.tableView];

    
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
            
            [cell addSubview:imageView];
            [cell addSubview:self.downButtonView];
            [cell addSubview:[self constructDownButtonView:cellHeight]];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row==1){
        NSString *simpleTableIdentifier = [NSString stringWithFormat:@"locationCell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if(cell== nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
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
