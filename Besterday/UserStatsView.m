//
//  UserStatsView.m
//  Besterday
//
//  Created by Larry Wei on 11/13/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "UserStatsView.h"
#import "MockUser.h"

@interface UserStatsView()
@end
@implementation UserStatsView


- (void)loadUser:(MockUser *) user{
    self.user = user;
    [self loadViews];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.containerView setFrame:self.bounds];
}

- (void) loadViews {
    if (self.user) {

    }
}

- (void)setup {
    NSLog(@"===Init Stats view!===");
    UINib *nib = [UINib nibWithNibName:@"UserStatsView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    [self addSubview:self.containerView];
    self.imageAsset.image = [UIImage imageNamed:@"stats"];
    self.value.text = @"92";
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

@end
