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
#import <Parse/Parse.h>
#import "BestieCell.h"

int const kBestieCellSize = 120;

@interface UserProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UserHeaderView *header;

// Bestie feed
@property NSArray *besties;
@property (weak, nonatomic) IBOutlet UICollectionView *bestieCollectionView;
@property (nonatomic, strong) BestieCell *prototypeCell;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
    // Header
    [self.header loadUser:[[MockUser alloc]initFromObject]];
    
    // Feed
    [self setupCollectionView];
    [self loadBesties];

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

- (void)setupCollectionView {
    self.bestieCollectionView.delegate = self;
    self.bestieCollectionView.dataSource = self;
    
    UINib *bestieCellNib = [UINib nibWithNibName:@"BestieCell" bundle:nil];
    [self.bestieCollectionView registerNib:bestieCellNib forCellWithReuseIdentifier:@"BestieCell"];
}

- (void)loadBesties {
    PFUser *user = [PFUser currentUser];
    [Bestie bestiesForUserWithTarget:user completion:^(NSArray *besties, NSError *error) {
        if (error == nil) {
            self.besties = besties;
            [self.bestieCollectionView reloadData];
            NSLog(@"Feed View: Bestie Feed -- loaded %ld besties", besties.count);
        } else {
            NSLog(@"Error loading besties: %@", error);
        }
    }];
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
    [self.navigationController pushViewController:[[MenuViewController alloc] init] animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeMake(kBestieCellSize, kBestieCellSize);
    return returnSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.besties.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BestieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BestieCell" forIndexPath:indexPath];
    cell.bestie = self.besties[indexPath.row];
    
    cell.parentVC = self;//.parentViewController;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


@end
