//
//  StarRatingView.h
//  StarRatingDemo
//
//  Created by HengHong on 5/4/13.
//  Copyright (c) 2013 Fixel Labs Pte. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface StarRatingView : UIView
@property (nonatomic) int userRating;
@property (nonatomic) int maxrating;
@property (nonatomic) int rating;
@property (nonatomic) BOOL animated;
@property (nonatomic) float kLabelAllowance;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) CALayer* tintLayer;

- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated;
@end