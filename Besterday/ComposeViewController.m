//
//  ComposeViewController.m
//  Besterday
//
//  Created by Wes Chao on 11/10/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "ComposeViewController.h"
#import "Parse.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *bestieTextView;

@end

@implementation ComposeViewController
- (IBAction)onPost:(id)sender {
    
    PFObject *bestie = [PFObject objectWithClassName:@"Bestie"];
    bestie[@"text"] = self.bestieTextView.text;

    
    [bestie saveInBackground];
    //TODO: go back to main view controller
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
