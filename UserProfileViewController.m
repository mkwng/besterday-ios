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
#import "FeedViewController.h"

@interface UserProfileViewController ()
@property (nonatomic, strong) UserHeaderView *header;

// Bestie feed
@property (nonatomic, strong) FeedViewController *feedVC;
@property (nonatomic, strong) UIView *feedView;
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
    // Header
    self.header = [[UserHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 215)];
    [self.header loadUser:[[MockUser alloc]initFromObject]];
    [self addView:self.header];
    
    // Feed
    self.feedVC = [[FeedViewController alloc] init];
    self.feedView = self.feedVC.view;
    self.feedView.frame = CGRectMake(0, self.header.frame.origin.y + self.header.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.header.frame.origin.y);
    NSLog(@"FRAMES: %@, %@", NSStringFromCGRect(self.header.frame), NSStringFromCGRect(self.feedView.frame));
    [self addView:self.feedView];

    self.view.backgroundColor = [UIColor orangeColor];
    self.view.alpha = .9;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Profile viewWillAppear");
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Grow" style:UIBarButtonItemStylePlain target:self action:@selector(onGrow)];
}

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

- (void)onMenu {
    NSLog(@"ALPHA: %f", self.view.alpha);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
