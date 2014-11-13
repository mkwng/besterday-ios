//
//  ComposeViewController.m
//  Besterday
//
//  Created by Wes Chao on 11/10/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "ComposeViewController.h"
#import "MenuViewController.h"
#import "Parse.h"
#import "Bestie.h"

@interface ComposeViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *bestieTextView;

// TODO: remove these, they're just for testing
@property (weak, nonatomic) IBOutlet UITableView *testTableView;
@property NSArray* besties;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    
    self.testTableView.dataSource = self;
    [self refreshData];
}

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu)];
}

- (void)onMenu {
    [self presentViewController:[[MenuViewController alloc] init] animated:YES completion:nil];
}

- (IBAction)onPost:(id)sender {
    
    PFObject *bestie = [PFObject objectWithClassName:@"Bestie"];
    bestie[@"text"] = self.bestieTextView.text;
    bestie[@"user"] = [PFUser currentUser];

    [bestie saveInBackground];
    
    //TODO: go back to main view controller
}


// TODO: remove these, they're just for testing
- (void) refreshData
{
    PFQuery *query = [PFQuery queryWithClassName:@"Bestie"];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld messages.", objects.count);
            
            self.besties = objects;
            [self.testTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [self.testTableView reloadData];
}

    
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.besties.count;
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    
    Bestie *bestie = self.besties[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", bestie.text, bestie.createdAt];
    
    return cell;
}
@end
