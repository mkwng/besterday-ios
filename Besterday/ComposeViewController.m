//
//  ComposeViewController.m
//  Besterday
//
//  Created by Wes Chao on 11/10/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "ComposeViewController.h"
#import "MenuViewController.h"
#import <Parse/Parse.h>
#import "Bestie.h"
#import "UserProfileViewController.h"

@interface ComposeViewController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) IBOutlet UIImageView *bestieImageView;
@property (weak, nonatomic) IBOutlet UITextView *bestieTextView;

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property UIImage* imageToAdd;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property NSArray* besties;

@property BOOL displayingImageOnly;
@property BOOL swipedLeft;
@property UIPercentDrivenInteractiveTransition *interactiveTransition;

@property (nonatomic, assign) BOOL isPostingTransition;
@property (nonatomic, assign) BOOL isPresenting;

@end

@implementation ComposeViewController

const NSString * kInitialText = @"What was the best thing that happened to you yesterday?";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];

    // get the list of all besties so that we can browse them
    PFUser *user = [PFUser currentUser];
    [Bestie bestiesForUserWithTarget:user completion:^(NSArray *besties, NSError *error) {
        if (error == nil) {
            self.besties = besties;
        } else {
            NSLog(@"Error loading besties: %@", error);
        }
    }];
    
    // set default color scheme for composing new besties
    if (!self.backgroundColor)
    {
        self.containerView.backgroundColor = [UIColor colorWithRed:237/255.0f green:196/255.0f blue:86/255.0f alpha:1.0f];
        self.bestieTextView.textColor = [UIColor whiteColor];
    }
    else
    {
        self.bestieTextView.textColor = self.textColor;
    }
    
    self.bestieTextView.delegate = self;
    
    // add the calendar page subview
    UINib *nib = [UINib nibWithNibName:@"CalendarView" bundle:nil];
    NSArray * objects = [nib instantiateWithOwner:self options:nil];
    
    UIView * calendarView = objects[0];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    calendarView.center = CGPointMake(window.center.x, 80);
    [self.containerView addSubview:calendarView];

    self.displayingImageOnly = NO;
    
    self.doneButton.backgroundColor = [UIColor colorWithRed:103/255.0f green:176/255.0f blue:153/255.0f alpha:1.0f];
    self.doneButton.layer.cornerRadius = 8;
    self.doneButton.clipsToBounds = YES;
    
    [self reloadData];
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    if (self.bestieImageView.image)
    {
        if (self.displayingImageOnly)
        {
            [UIView animateWithDuration:1.0 animations:^{
                self.containerView.alpha = 1.0f;
                self.bestieImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                
            } completion:nil];
            
            self.displayingImageOnly = NO;
        }
        else
        {
            [UIView animateWithDuration:1.0 animations:^{
                self.containerView.alpha = 0.0f;
                self.bestieImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:nil];
            self.displayingImageOnly = YES;
        }
    }
}


- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu)];
}

- (void) reloadData
{
    UIColor *textColor = [UIColor whiteColor];
    switch (self.backgroundColor) {
        case BestieCellColorWhite:
            self.containerView.backgroundColor = [UIColor colorWithRed:227/255.0f green:223/255.0f blue:223/255.0f alpha:1.0f];
            textColor = [UIColor blackColor];
            break;
        case BestieCellColorBlack:
            self.containerView.backgroundColor = [UIColor colorWithRed:66/255.0f green:61/255.0f blue:63/255.0f alpha:1.0f];
            break;
        case BestieCellColorGreen:
            self.containerView.backgroundColor = [UIColor colorWithRed:107/255.0f green:186/255.0f blue:159/255.0f alpha:1.0f];
            break;
        case BestieCellColorOrange:
            self.containerView.backgroundColor = [UIColor colorWithRed:228/255.0f green:137/255.0f blue:87/255.0f alpha:1.0f];
            break;
    }
    
    self.bestieTextView.textColor = textColor;
    
    if (self.bestie)
    {
        self.bestieTextView.text = self.bestie.text;
    
        self.monthLabel.text = [self.bestie createMonth];
        self.dayLabel.text = [self.bestie createDay];
        
        if (self.imageToAdd)
            self.bestieImageView.image = self.imageToAdd;
        else
            self.bestieImageView.image = self.bestie.image;

        // Make the background color slightly transparent if there is an image
        CGFloat alpha = 1.0f;
        if (self.bestieImageView.image)
            alpha = 0.7f;
        
        CGFloat h, s, b, a;
        if ([self.containerView.backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a])
            self.containerView.backgroundColor = [UIColor colorWithHue:h saturation:s brightness:b alpha:alpha];
        
        self.bestieImageView.backgroundColor = self.containerView.backgroundColor;
    }
    else
    {
        NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

        [formatter setDateFormat:@"MMM"];
        self.monthLabel.text = [formatter stringFromDate:yesterday];

        [formatter setDateFormat:@"d"];
        self.dayLabel.text = [formatter stringFromDate:yesterday];
        
        self.bestieTextView.text = (NSString *)kInitialText;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // center the text vertically as you type
    [self.bestieTextView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.bestieTextView removeObserver:self forKeyPath:@"contentSize"];
}


// center the text vertically as you type
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    UITextView *txtview = object;
    CGFloat topoffset = ([txtview bounds].size.height - [txtview contentSize].height * [txtview zoomScale])/2.0;
    topoffset = ( topoffset < 0.0 ? 0.0 : topoffset );
    txtview.contentOffset = (CGPoint){.x = 0, .y = -topoffset};
}

- (BOOL)stringIsWhitespaceOrEmpty:(NSString *)str {
    NSString *probablyEmpty = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [probablyEmpty isEqualToString:@""];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.doneButton setEnabled:![self stringIsWhitespaceOrEmpty:self.bestieTextView.text]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    // if we're composing a new bestie, nuke the placeholder text as soon as you click in
    if (!self.bestie && [self.bestieTextView.text isEqualToString:(NSString *)kInitialText]) {
        self.bestieTextView.text = @"";
        [self.doneButton setEnabled:NO];
    }
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        // find the current bestie in the array
        for (int ii = 0; ii < self.besties.count; ii++) {
            Bestie * bestie = (Bestie*) self.besties[ii];
            
            if ([bestie.objectId isEqualToString:self.bestie.objectId ])
            {
                if ([sender velocityInView:self.view].x > 0 && ii > 0)
                {
                    self.swipedLeft = NO;
                    [self showNewBestie:self.besties[ii-1] withColor:(self.backgroundColor - 1) % 4];
                }
                else if ([sender velocityInView:self.view].x < 0 && ii < self.besties.count - 1)
                {
                    self.swipedLeft = YES;
                    [self showNewBestie:self.besties[ii+1] withColor:(self.backgroundColor + 1) % 4];

                    break;
                }
            }
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        float location = [sender locationInView:self.view].x / self.view.frame.size.width;
        location = (self.swipedLeft) ? 1 - location : location;
        
        [self.interactiveTransition updateInteractiveTransition:location];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ((self.swipedLeft && [sender velocityInView:self.view].x < 0) ||
            (!self.swipedLeft && [sender velocityInView:self.view].x > 0))
        {
            [self.interactiveTransition finishInteractiveTransition];
        }
        else
        {
            [self.interactiveTransition cancelInteractiveTransition];
        }
    }

}

- (void) showNewBestie: (Bestie *) bestie withColor: (BestieCellColor) color {
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.bestie = bestie;
    vc.backgroundColor = color;
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)onMenu {
    [self presentViewController:[[MenuViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)onPhoto:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // get the picked image
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];

    self.bestieImageView.image = image;
    self.imageToAdd = image;

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self reloadData];
}

// TODO: make the animation post-posting better. Also, reuse completion blocks?
- (IBAction)onPost:(id)sender {
    [self.doneButton setEnabled:NO];
    if (self.bestie) {
        // Update the existing bestie with new data
        [Bestie saveBestie:self.bestie text:self.bestieTextView.text date:self.bestie.createdAt withImage:self.imageToAdd completion:^(BOOL succeeded, NSError *error) {
            [self postingCompletion:succeeded error:error];
        }];
    } else {
        // Create a new bestie
        [Bestie createNewestBestie:self.bestieTextView.text withImage:self.imageToAdd completion:^(BOOL succeeded, NSError *error) {
            [self postingCompletion:succeeded error:error];
        }];
    }
}

-(void)postingCompletion:(BOOL)succeeded error:(NSError *)error {
    if (error != nil) {
        NSLog(@"Posting ERROR: %@", error);
        return;
    }
    NSLog(@"Bestie successfully saved/updated!");
    self.isPostingTransition = YES;
    
    UserProfileViewController *vc = [[UserProfileViewController alloc] init];
    vc.shouldAnimateCells = NO;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Transition delegate methods

- (NSTimeInterval)transitionDuration:(id )transitionContext {
    return 0.5;
}

// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id) transitionContext {
    NSLog(@"animateTransition");
    // Different custom transition for post-posting behavior
    if (self.isPostingTransition) {
        NSLog(@"animateTransition -- post-post");
        [self animatePostingTransition:transitionContext];
        return;
    }
    
    // Animation transition for card-to-card swiping
    UIView *containerView = [transitionContext containerView];
    ComposeViewController *toViewController = (ComposeViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    CGFloat initialX = (self.swipedLeft) ? window.frame.size.width : -window.frame.size.width;
    
    toViewController.view.frame = CGRectMake(initialX, 0, window.frame.size.width, window.frame.size.height);
    [containerView addSubview:toViewController.view];
    
    [toViewController.view layoutSubviews];
    
    [UIView animateWithDuration:0.5 animations:^{
        toViewController.view.frame = window.frame;
    } completion:^(BOOL finished) {
        BOOL completed = ![transitionContext transitionWasCancelled];
        [transitionContext completeTransition:completed];
    }];
}

- (void)animatePostingTransition:(id) transitionContext {
    UIView *containerView = [transitionContext containerView];
    UserProfileViewController *toViewController = (UserProfileViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if (self.isPresenting) {
        NSLog(@"I'm presenting");
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
    NSLog(@"animationControllerForPresentedController");
    if (self.isPostingTransition) {
        self.isPresenting = YES;
    }
    return self;
}

- (id)animationControllerForDismissedController:(UIViewController *)dismissed {
    NSLog(@"animationControllerForDismissedController");
    if (self.isPostingTransition) {
        self.isPresenting = NO;
    }
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.isPostingTransition) {
        return nil;
    }
    self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
    self.interactiveTransition.completionSpeed = 0.99;
    return self.interactiveTransition;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


@end
