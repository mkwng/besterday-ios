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

- (PFUser*) createDate
{
    return (self[@"createDate"]) ? self[@"createDate"] : self.createdAt;
}

+ (void) bestie: (NSString *)text
{
    [Bestie bestie:text completion:nil];
}

+ (void) bestie: (NSString *)text completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    PFObject *bestie = [PFObject objectWithClassName:@"Bestie"];
    bestie[@"text"] = text;
    bestie[@"user"] = [PFUser currentUser];
    bestie[@"createDate"] = [NSDate date];
    
    [bestie saveInBackgroundWithBlock:completion];
}


// fetches all the besties for the current user, and then calls selector, passing an array of besties.
+ (void) bestiesForUserWithTarget: (PFUser*) user completion:(void (^)(NSArray *besties, NSError *error))completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"Bestie"];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:user];
    [query orderByDescending:@"createdAt"];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query findObjectsInBackgroundWithBlock:completion];
}
+ (void) mostRecentBestieForUser: (PFUser*) user completion:(void (^)(Bestie *bestie))completion
{
    [Bestie bestiesForUserWithTarget:user completion:^(NSArray *besties, NSError *error) {
        //TODO: handle errors
        completion(besties[0]);
    }];
}

@end
