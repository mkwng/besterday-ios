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



- (void)loadUser:(MockUser *)user;

@end
