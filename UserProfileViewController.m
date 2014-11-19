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

@interface UserProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UserHeaderView *header;

// Bestie feed
@property NSArray *besties;
@property (weak, nonatomic) IBOutlet UICollectionView *bestieCollectionView;
@property (nonatomic, strong) BestieCell *prototypeCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (nonatomic, assign) CGFloat headerHeightConstant;

@end

@implementation UserProfileViewController


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffset = scrollView.contentOffset.y;
//    NSLog(@"Constraint %f", self.headerHeightConstraint.constant);
    if (contentOffset < 0) {
        self.headerHeightConstraint.constant = self.headerHeightConstant;
        CALayer *layer = self.header.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0/-500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (-contentOffset/self.headerHeightConstant)* M_PI_2, 1, 0, 0);
        layer.transform = rotationAndPerspectiveTransform;
        
        /*CALayer *bestieLayer = self.bestieCollectionView.layer;
        CATransform3D rotationAndPerspectiveTransform2 = CATransform3DIdentity;
        rotationAndPerspectiveTransform2.m34 = 1.0/-500;
        rotationAndPerspectiveTransform2 = CATransform3DRotate(rotationAndPerspectiveTransform2, (-contentOffset/self.headerHeightConstant)* M_PI_2, 1, 0, 0);
        bestieLayer.transform = rotationAndPerspectiveTransform2;*/
        
    }
    else  if (contentOffset > 0) {
        if (self.headerHeightConstraint.constant <= self.headerHeightConstant) {
            self.headerHeightConstraint.constant = self.headerHeightConstant - contentOffset;
            
            CALayer *layer = self.header.layer;
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0/-500;
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (-contentOffset/self.headerHeightConstant)* M_PI_2, 1, 0, 0);
            layer.transform = rotationAndPerspectiveTransform;
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerHeightConstant = 240;
    
    // Header
    [self.header loadUser:[[MockUser alloc]initFromObject]];
    
    // Feed
    [self setupCollectionView];
    [self loadBesties];

    self.view.backgroundColor = [UIColor blackColor];
    self.view.alpha = 1;
    
    [self setupNavigationBar];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Profile viewWillAppear");
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu)];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Grow" style:UIBarButtonItemStylePlain target:self action:@selector(onGrow)];
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
- (IBAction)onLongPress:(UILongPressGestureRecognizer *)sender {
    NSLog(@"Long press triggered");
    [self onMenu];
}


- (void) addView:(UIView *)view {
    [self.view addSubview:view];
    [self.view setNeedsLayout];
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
}

// allow tiles to touch each other horizontally
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

// allow tiles to touch each other vertically
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    // make squares equal to half the width of the frame
    CGSize returnSize = CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.width/2);
    return returnSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.besties.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BestieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BestieCell" forIndexPath:indexPath];
    cell.bestie = self.besties[indexPath.row];
    
    // alternate colors
    [cell setColor: indexPath.row % 4];
    cell.parentVC = self;
    
    CGRect frame = cell.frame;
    CGPoint translation = [collectionView.panGestureRecognizer translationInView:collectionView.superview];
    if (translation.y > 0) {
        if (indexPath.row % 2 == 0) {
            cell.frame = CGRectMake(0, 0, 0, 0);
        }
        else {
            cell.frame = CGRectMake(self.bestieCollectionView.frame.size.width, 0, 0, 0);
        }
    } else {
        if (indexPath.row % 2 == 0) {
            cell.frame = CGRectMake(0, self.bestieCollectionView.frame.size.height, 0, 0);
        }
        else {
            cell.frame = CGRectMake(self.bestieCollectionView.frame.size.width, self.bestieCollectionView.frame.size.height, 0, 0);
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^(void){
        cell.frame = frame;
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

// DEBUG: just for testing; not wired up any more, but if you need it, make a button or something to trigger these
- (void)onMenu {
    NSLog(@"ALPHA: %f", self.view.alpha);
    [self presentViewController:[[MenuViewController alloc] init] animated:YES completion:nil];
}

- (void)onGrow{
    [UIView animateWithDuration:2.0 animations:^{
        CGRect frame = self.header.frame;
        frame.size.height =500;
        self.header.frame = frame;
    }];
    //    [self.view setNeedsLayout];
}
- (BOOL) prefersStatusBarHidden
{
    return YES;
}

@end
