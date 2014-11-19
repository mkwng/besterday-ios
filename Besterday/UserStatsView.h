//
//  UserStatsView.h
//  Besterday
//
//  Created by Larry Wei on 11/13/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MockUser.h"

@interface UserStatsView : UIView
@property (nonatomic, strong) MockUser *user;
@property (weak, nonatomic) IBOutlet UIImageView *imageAsset;
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *backBar;
@property (weak, nonatomic) IBOutlet UIView *progressBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBarHeight;
@property (weak, nonatomic) IBOutlet UIView *progressBar2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressBar2Height;


- (void)loadUser:(MockUser *)user;

@end
