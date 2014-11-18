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

@interface ComposeViewController ()<UITextViewDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *bestieTextView;

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property UIImage* imageToAdd;
@property (weak, nonatomic) IBOutlet UIImageView *bestieImageView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property NSArray* besties;

@property BOOL displayingImageOnly;
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
        // Make the background color slightly transparent if there is an image
        CGFloat alpha = 1.0f;
        if (self.bestie.image)
            alpha = 0.7f;
        
        CGFloat h, s, b, a;
        if ([self.backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a])
            self.backgroundColor = [UIColor colorWithHue:h saturation:s brightness:b alpha:alpha];
        
        // set the background and text colors
        self.containerView.backgroundColor = self.backgroundColor;
        self.bestieImageView.backgroundColor = self.backgroundColor;
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
    [self reloadData];
}
- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    if (self.bestie.image)
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
    if (self.bestie)
    {
        self.bestieTextView.text = self.bestie.text;
    
        self.monthLabel.text = [self.bestie createMonth];
        self.dayLabel.text = [self.bestie createDay];
        
        self.bestieImageView.image = self.bestie.image;
    }
    else
    {
        NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

        [formatter setDateFormat:@"MMM"];
        self.monthLabel.text = [formatter stringFromDate:yesterday];

        [formatter setDateFormat:@"d"];
        self.dayLabel.text = [formatter stringFromDate:yesterday];
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

- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // if we're composing, remove the help text
    if (!self.bestie && [self.bestieTextView.text isEqualToString: (NSString *)kInitialText])
        self.bestieTextView.text = @"";
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView;
{
    // if we're composing a new bestie and the text is empty, place the help text
    if (!self.bestie && [self.bestieTextView.text isEqualToString: @""])
        self.bestieTextView.text = (NSString *)kInitialText;
}

- (IBAction)onPan:(UIPanGestureRecognizer *)sender
{
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        // find the current bestie in the array
        for (int ii = 0; ii < self.besties.count; ii++) {
            Bestie * bestie = (Bestie*) self.besties[ii];
            
            if ([bestie.objectId isEqualToString:self.bestie.objectId ])
            {
                if ([sender velocityInView:self.view].x > 0 && ii > 0)
                {
                    self.bestie = self.besties[ii-1];
                }
                else if ([sender velocityInView:self.view].x < 0 && ii < self.besties.count - 1)
                {
                    self.bestie = self.besties[ii+1];
                    break;
                }
            }
        }
        [self reloadData];
    }
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
}

- (IBAction)onPost:(id)sender {
    // distinguish between compose new and edit
    if (self.bestie)
    {
        self.bestie.image = self.imageToAdd;
        self.bestie.text = self.bestieTextView.text;
    }
    else
    {
        [Bestie bestie:self.bestieTextView.text withImage:self.imageToAdd];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
