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

@synthesize text;
- (NSString*) text
{
    return self[@"text"];
}

@synthesize user;
- (PFUser*) user
{
    return self[@"user"];
}

@synthesize createDate;
- (PFUser*) createDate
{
    return (self[@"createDate"]) ? self[@"createDate"] : self.createdAt;
}

#pragma mark Bestie creation methods

+ (void) bestie: (NSString *)text
{
    [Bestie bestie:text date:[NSDate date] completion:nil];
}

+ (void) bestie: (NSString *)text date:(NSDate *)date {
    [Bestie bestie:text date:date completion:nil];
}

+ (void) bestie: (NSString *)text date:(NSDate *)date completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    PFObject *bestie = [PFObject objectWithClassName:@"Bestie"];
    bestie[@"text"] = text;
    bestie[@"user"] = [PFUser currentUser];
    bestie[@"createDate"] = date;
    
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
