//
//  schoolViewController.h
//  sculz
//
//  Created by veddislabs on 19/12/2014.
//  Copyright (c) 2014 self. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "school.h"

@interface schoolViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) school *school;

@end
