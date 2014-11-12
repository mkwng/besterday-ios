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

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *bestieTextView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
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
    
    [bestie saveInBackground];
    
    //TODO: go back to main view controller
}
@end
