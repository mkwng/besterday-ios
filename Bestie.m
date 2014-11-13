//
//  Bestie.m
//  Besterday
//
//  Created by Wes Chao on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "Bestie.h"

@implementation Bestie


+ (NSString *)parseClassName {
    return @"Bestie";
}

- (NSString*) text
{
    return self[@"text"];
}

- (PFUser*) user
{
    return self[@"user"];
}

// fetches all the besties for the current user, and then calls selector, passing an array of besties.
+ (void) bestiesWithTarget: (id) target selector:(SEL)selector
{
    PFQuery *query = [PFQuery queryWithClassName:@"Bestie"];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %ld messages.", objects.count);

            [target performSelector:selector withObject:objects];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


@end
