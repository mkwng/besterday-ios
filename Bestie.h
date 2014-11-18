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
@property UIImage* image;

// returns a date in the format "Nov 9"
@property (readonly, nonatomic) NSString* createDate;
@property (readonly, nonatomic) NSString* createMonth;
@property (readonly, nonatomic) NSString* createDay;
@property (readonly, nonatomic) NSString* createFullDate;

// Bestie creation
+ (void)createNewestBestie:(NSString *)text withImage: (UIImage*) image completion:(void (^)(BOOL succeeded, NSError *error)) completion;
+ (void) saveBestie:(Bestie *) bestie text:(NSString *)text date:(NSDate *)date withImage:(UIImage*) image completion:(void (^)(BOOL succeeded, NSError *error)) completion;
    
// Bestie fetching
+ (void) bestiesForUserWithTarget: (PFUser*) user completion:(void (^)(NSArray *besties, NSError *error))completion;

+ (void) mostRecentBestieForUser: (PFUser*) user completion:(void (^)(Bestie *bestie))completion;

@end
