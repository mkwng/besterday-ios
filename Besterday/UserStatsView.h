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

- (void)loadUser:(MockUser *)user;

@end
