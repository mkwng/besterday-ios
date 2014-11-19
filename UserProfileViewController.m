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

@interface UserProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate,UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) IBOutlet UserHeaderView *header;
@property (nonatomic, assign) BOOL isPresenting;

// Bestie feed
@property NSArray *besties;
@property (weak, nonatomic) IBOutlet UICollectionView *bestieCollectionView;
@property (nonatomic, strong) BestieCell *prototypeCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (nonatomic, assign) CGFloat headerHeightConstant;

@end

@implementation UserProfileViewController


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Always animate cells when scrolling
    self.shouldAnimateCells = YES;
    
    CGFloat contentOffset = scrollView.contentOffset.y;
    //NSLog(@"Constraint %f", self.headerHeightConstraint.constant);
    if (contentOffset < 0) {
        self.headerHeightConstraint.constant = self.headerHeightConstant;
        CALayer *layer = self.header.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0/-500;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (-contentOffset/self.headerHeightConstant)* M_PI_2, 1, 0, 0);
        layer.transform = rotationAndPerspectiveTransform;
        
        self.header.alpha = 1 - (-contentOffset/self.headerHeightConstant);
        //NSLog(@"ALPHA: %f", self.header.alpha);
        
        /*CALayer *bestieLayer = self.bestieCollectionView.layer;
        CATransform3D rotationAndPerspectiveTransform2 = CATransform3DIdentity;
        rotationAndPerspectiveTransform2.m34 = 1.0/-500;
        rotationAndPerspectiveTransform2 = CATransform3DRotate(rotationAndPerspectiveTransform2, (-contentOffset/self.headerHeightConstant)* M_PI_2, 1, 0, 0);
        bestieLayer.transform = rotationAndPerspectiveTransform2;*/
        
    }
    else  if (contentOffset > 0) {
        if (self.headerHeightConstraint.constant <= self.headerHeightConstant) {
            self.header.alpha = 1 - (contentOffset/self.headerHeightConstant);
            //NSLog(@"ALPHA: %f", self.header.alpha);
            self.headerHeightConstraint.constant = self.headerHeightConstant - contentOffset;
            
            CALayer *layer = self.header.layer;
            CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
            rotationAndPerspectiveTransform.m34 = 1.0/-500;
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, (-contentOffset/self.headerHeightConstant)* M_PI_2, 1, 0, 0);
            layer.transform = rotationAndPerspectiveTransform;
            
            
        }
        
    }
}

- (id)init {
    self = [super init];
    // Animations are enabled by default, but may be disabled by certain views
    self.shouldAnimateCells = YES;
    return self;
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
    
    //[self setupNavigationBar];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Profile viewWillAppear");
}

- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu)];
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
            // Don't reanimate the cells on further reloads of data
            self.shouldAnimateCells = NO;
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

    if (self.shouldAnimateCells) {
        cell.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            cell.alpha = 1;
        }];
        [UIView animateWithDuration:0.1 animations:^(void){
            cell.frame = frame;
        }];
    } else {
        cell.frame = frame;
    }

    cell.layer.masksToBounds = NO;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 0.5;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0, 5);
    cell.layer.shadowOpacity = .5;
    cell.layer.shadowRadius = 2.0;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

// DEBUG: just for testing; not wired up any more, but if you need it, make a button or something to trigger these
- (void)onMenu {
    //NSLog(@"ALPHA: %f", self.view.alpha);
    [self presentViewController:[[MenuViewController alloc] init] animated:YES completion:nil];
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

#pragma mark - Transition delegate methods

- (NSTimeInterval)transitionDuration:(id )transitionContext {
    return 0.5;
}

- (void)animateTransition:(id) transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toViewController = (UserProfileViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (self.isPresenting) {
        NSLog(@"I'm presenting");
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        toViewController.view.frame = window.frame;
        [containerView addSubview:toViewController.view];
        toViewController.view.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            toViewController.view.alpha = 1;
        } completion:^(BOOL finished) {
            NSLog(@"Completion");
            BOOL completed = ![transitionContext transitionWasCancelled];
            [transitionContext completeTransition:completed];
        }];
    } else {
        NSLog(@"I'm dismissing");
        [UIView animateWithDuration:0.4 animations:^{
            fromViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromViewController.view removeFromSuperview];
        }];
    }
}

- (id)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresenting = YES;
    return self;
}

- (id)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresenting = NO;
    return self;
}

@end
