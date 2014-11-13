//
//  UserProfileViewController.m
//  Besterday
//
//  Created by Larry Wei on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UserHeaderView.h"
#import "UserStatsView.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController

- (void) addView:(UIView *)view {
    [self.view addSubview:view];
    [self.view setNeedsLayout];
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserHeaderView *header = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    [header loadUser:[[MockUser alloc]initFromObject]];
    [self addView:header];
    
    
    
    
    
    self.navigationController.navigationBar.translucent = NO;

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
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
