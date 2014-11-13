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
#import "MenuViewController.h"

@interface UserProfileViewController ()
@property (nonatomic, strong) UserHeaderView *header;

@end

@implementation UserProfileViewController

- (void) addView:(UIView *)view {
    [self.view addSubview:view];
    [self.view setNeedsLayout];
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
}

- (void)onGrow{
    [UIView animateWithDuration:2.0 animations:^{
        CGRect frame = self.header.frame;
        frame.size.height =500;
        self.header.frame = frame;
    }];
    /*
    self.header.userImageHeightConstraint.constant += 20;
    self.header.userImageWidthConstraint.constant +=20;*/
    
    /*CGRect frame = self.header.frame;
    frame.size.height -=self.header.statsContainerView.frame.size.height;
    self.header.frame = frame;
    CGRect statsFrame = self.header.statsContainerView.frame;
    statsFrame.size.height = 0;
    self.header.statsContainerView.frame = statsFrame;
    [self.header.statsContainerView removeFromSuperview];
    NSLog(@"%f", self.header.statsContainerView.frame.size.height);*/

    
//    [self.view setNeedsLayout];
}
- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Grow" style:UIBarButtonItemStylePlain target:self action:@selector(onGrow)];
}

- (void)onMenu {
    NSLog(@"ALPHA: %f", self.view.alpha);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.header = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 215)];
    [self.header loadUser:[[MockUser alloc]initFromObject]];
    [self addView:self.header];

    self.navigationController.navigationBar.translucent = NO;
    [self setupNavigationBar];
    self.view.backgroundColor = [UIColor orangeColor];
    self.view.alpha = .9;
    
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
