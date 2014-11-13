//
//  LoginViewController.m
//  Avalon
//
//  Created by Wes Chao on 11/6/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "LoginViewController.h"
#import "Parse.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ComposeViewController.h"
#import "MenuViewController.h"
#import "Bestie.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            
            // make a request for the user's real name
            // TODO: if the user already exists, we don't need this
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // result is a dictionary with the user's Facebook data
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    user.username = userData[@"name"];
                    [user saveInBackground];

//                    NSString *facebookID = userData[@"id"];
//                    NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
                    
                }
            }];
            
            //TODO: put this somewhere common so it's not duplicated here and in the AppDelegate
            // if the user hasn't posted a bestie for yesterday, show the compose view
            [Bestie mostRecentBestieForUser:[PFUser currentUser] completion:^(Bestie *bestie) {
                
                // get a string representing yesterday
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MMM d"];
                NSString* yesterdayString = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:-86400]];
                
                UIViewController * vc;
                NSLog(@"%@ %@", yesterdayString, bestie.createDate);
                
                if ([yesterdayString isEqualToString:bestie.createDate])
                {
                    NSLog(@"Most recent bestie is yesterday -- showing main view");
                    vc = [[MenuViewController alloc] init];
                }
                else
                {
                    NSLog(@"Most recent bestie is older than yesterday -- showing compose view");
                    vc = [[ComposeViewController alloc] init];
                }

                vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:vc animated:YES completion:nil];

            }];
        }
    }];
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
