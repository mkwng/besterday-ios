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

- (void) setText:(NSString *)text {
    self[@"text"] = text;
    [self saveInBackground];    
}
- (NSString*) text
{
    return self[@"text"];
}

- (void) setImage:(UIImage *)image
{
    // TODO: clean this up
    NSDate * date = (self[@"createDate"]) ? self[@"createDate"] : self.createdAt;

    NSDate * hackDate = [date dateByAddingTimeInterval:86400];
    [Bestie saveBestie:self text:self.text date:hackDate withImage:image completion:nil];
}
- (UIImage *) image
{
    PFFile *theImage = self[@"imageFile"];
    NSData *imageData = [theImage getData];
    return [UIImage imageWithData:imageData];
}

@synthesize user;
- (PFUser*) user
{
    return self[@"user"];
}

- (NSString*) createDate
{
    NSDate *date = (self[@"createDate"]) ? self[@"createDate"] : self.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d"];
    
    return [formatter stringFromDate:date];
}
- (NSString*) createMonth
{
    NSDate *date = (self[@"createDate"]) ? self[@"createDate"] : self.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    
    return [formatter stringFromDate:date];
}
- (NSString*) createDay
{
    NSDate *date = (self[@"createDate"]) ? self[@"createDate"] : self.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"d"];
    
    return [formatter stringFromDate:date];
}
- (NSString*) createFullDate
{
    NSDate *date = (self[@"createDate"]) ? self[@"createDate"] : self.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE, MMM d"];
    return [[formatter stringFromDate:date] uppercaseString];
}

#pragma mark Bestie creation methods

+ (void)createNewestBestie:(NSString *)text withImage: (UIImage*) image completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    [Bestie bestie:text date:[NSDate date] withImage:image completion:completion];
}

+ (void)bestie: (NSString *)text date:(NSDate *)date withImage:(UIImage*) image completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    PFObject *bestie = [PFObject objectWithClassName:@"Bestie"];
    [Bestie saveBestie:(Bestie *)bestie text:text date:date withImage:image completion:completion];
}

+ (void)saveBestie:(Bestie *) bestie text:(NSString *)text date:(NSDate *)date withImage:(UIImage*) image completion:(void (^)(BOOL succeeded, NSError *error)) completion {
    bestie[@"text"] = text;
    bestie[@"user"] = [PFUser currentUser];
    
    // Hack for backfilling data
    bestie[@"createDate"] = [date dateByAddingTimeInterval:-86400];
    
    if (image) {
        // Resize image
//        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        
        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
        [image drawInRect: CGRectMake(0, 0, 604, 960)];
        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.5f);
        
        // upload the image
        PFFile *imageFile = [PFFile fileWithName:@"BestieImage.jpg" data:imageData];
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Create a PFObject around a PFFile and associate it with the current user
                [bestie setObject:imageFile forKey:@"imageFile"];
                [bestie saveInBackgroundWithBlock:completion];
            }
            else{
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        } progressBlock:nil];
    } else {
        [bestie saveInBackgroundWithBlock:completion];
    }
}

// fetches all the besties for the current user, and then calls selector, passing an array of besties.
+ (void) bestiesForUserWithTarget: (PFUser*) user completion:(void (^)(NSArray *besties, NSError *error))completion
{
    NSLog(@"Finding all besties with user");
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
