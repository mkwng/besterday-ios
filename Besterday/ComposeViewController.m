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

@interface ComposeViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *bestieTextView;

// TODO: remove these, they're just for testing
@property (weak, nonatomic) IBOutlet UITableView *testTableView;
@property NSArray* besties;

@end

@implementation ComposeViewController

const NSString * kInitialText = @"What was the best thing that happened to you yesterday?";

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0f green:196/255.0f blue:86/255.0f alpha:1.0f];
    self.bestieTextView.textColor = [UIColor whiteColor];
    
    if (self.bestie)
        self.bestieTextView.text = self.bestie.text;
    
    self.bestieTextView.delegate = self;
    
    // TODO: remove; for testing only
    self.testTableView.dataSource = self;
    self.testTableView.delegate = self;
    [Bestie bestiesForUserWithTarget:[PFUser currentUser] completion:^(NSArray *besties, NSError *error) {
        if (!error) {
            self.besties = besties;
            [self.testTableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
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
    if (!self.bestie && [self.bestieTextView.text isEqualToString: kInitialText])
        self.bestieTextView.text = @"";
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView;
{
    // if we're composing a new bestie and the text is empty, place the help text
    if (!self.bestie && [self.bestieTextView.text isEqualToString: @""])
        self.bestieTextView.text = kInitialText;
}


- (void)onMenu {
    [self presentViewController:[[MenuViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)onPost:(id)sender {
    // distinguish between compose new and edit
    if (self.bestie)
    {
        self.bestie.text = self.bestieTextView.text;
    }
    else
    {
        [Bestie bestie:self.bestieTextView.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


// TODO: remove these, they're just for testing
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   return @"DEBUG - for testing only";
}
    
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.besties.count;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    
    Bestie *bestie = self.besties[indexPath.row];
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", bestie.text, bestie.createDate];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    
    vc.bestie = self.besties[indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];

}


@end
