//
//  MockUser.m
//  Besterday
//
//  Created by Larry Wei on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MockUser.h"

@interface MockUser()
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *picture;
@property (nonatomic, strong) NSString *tagline;

@end
@implementation MockUser

- (id)initFromObject {
    self = [super init];
    if (self) {
        self.name = @"Larry Wei";
        self.picture = [UIImage imageNamed:@"user_pic"];
        self.tagline = @"is doing swell!";
    }
    return self;
}

- (NSString *)getName {
    return self.name;
}

- (NSString *)getTagline {
    return self.tagline;
}

@end
