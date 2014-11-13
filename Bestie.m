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


@end
