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

@interface ComposeViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *bestieTextView;

- (void)setupNavigationBar;

// TODO: remove these, they're just for testing
@property (weak, nonatomic) IBOutlet UITableView *testTableView;
@property NSArray* besties;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
    // TODO: remove; for testing only
    self.testTableView.dataSource = self;
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


- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu)];
}

- (void)onMenu {
    [self presentViewController:[[MenuViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)onPost:(id)sender {
    [Bestie bestie:self.bestieTextView.text];
    
    //TODO: go back to main view controller
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
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d"];

    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", bestie.text, [formatter stringFromDate:bestie.createDate]];
    
    return cell;
}
@end
