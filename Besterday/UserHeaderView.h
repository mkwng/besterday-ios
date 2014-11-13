//
//  UserHeaderView.h
//  
//
//  Created by Larry Wei on 11/12/14.
//
//

#import <UIKit/UIKit.h>
#import "MockUser.h"

@interface UserHeaderView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userImageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIView *statsContainerView;


- (void)loadUser:(MockUser *)user;
@end
