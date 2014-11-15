//
//  UserHeaderView.h
//  
//
//  Created by Larry Wei on 11/12/14.
//
//

#import <UIKit/UIKit.h>
#import "MockUser.h"
#import "UserStatsView.h"

@interface UserHeaderView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *statsContainerView;
@property (weak, nonatomic) IBOutlet UserStatsView *test;


- (void)loadUser:(MockUser *)user;
@end
