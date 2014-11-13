//
//  MockUser.h
//  Besterday
//
//  Created by Larry Wei on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockUser : NSObject

- (id)initFromObject;

- (NSString *)getName;
- (UIImage *)getPicture;
- (NSString *)getTagline;

@end
