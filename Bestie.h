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

@end
