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

@interface ComposeViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *bestieTextView;

// TODO: remove these, they're just for testing
@property (weak, nonatomic) IBOutlet UITableView *testTableView;
@property NSArray* besties;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property UIImage* imageToAdd;
@property (weak, nonatomic) IBOutlet UIImageView *bestieImageView;

@end

@implementation ComposeViewController

const NSString * kInitialText = @"What was the best thing that happened to you yesterday?";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0f green:196/255.0f blue:86/255.0f alpha:1.0f];
    self.bestieTextView.textColor = [UIColor whiteColor];
    
    self.bestieTextView.delegate = self;
    
    // add the calendar page subview
    UINib *nib = [UINib nibWithNibName:@"CalendarView" bundle:nil];
    NSArray * objects = [nib instantiateWithOwner:self options:nil];
    
    UIView * calendarView = objects[0];
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    calendarView.center = CGPointMake(window.center.x, 120);
    [self.view addSubview:calendarView];

    [self reloadData];
}


- (void)setupNavigationBar {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Grow" style:UIBarButtonItemStylePlain target:self action:@selector(onGrow)];
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


- (void)onMenu {
    [self presentViewController:[[MenuViewController alloc] init] animated:YES completion:nil];
}
- (IBAction)onPhoto:(id)sender {
    // TODO: get an image off the phone
    UIImage *image = [UIImage imageNamed:@"CalendarImage"];
    
    self.imageToAdd = image;
    
    //TODO: add the image as a background view
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
