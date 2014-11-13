//
//  Bestie.h
//  Besterday
//
//  Created by Wes Chao on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <Parse/Parse.h>

@interface Bestie : PFObject<PFSubclassing>

@property (nonatomic) NSString* text;
@property (nonatomic) PFUser* user;

// this is a hack so that we can backfill some past data
@property (nonatomic) NSDate* createDate;

+ (void) bestiesForUserWithTarget: (PFUser*) user completion:(void (^)(NSArray *besties, NSError *error))completion;
+ (void) bestie: (NSString *)text;
+ (void) mostRecentBestieForUser: (PFUser*) user completion:(void (^)(Bestie *bestie))completion;
@end
