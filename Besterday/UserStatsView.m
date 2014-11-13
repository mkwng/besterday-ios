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
    [self.containerView setFrame:self.frame];
}

- (void) loadViews {
    if (self.user) {

    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSLog(@"===Init Stats view!===");
    if (self) {
        
        UINib *nib = [UINib nibWithNibName:@"UserStatsView" bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        [self addSubview:self.containerView];
        
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
