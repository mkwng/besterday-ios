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
@property (strong, nonatomic) IBOutlet UIView *contentView;


@end
@implementation UserStatsView


- (void)loadUser:(MockUser *) user{
    self.user = user;
    [self loadViews];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setFrame:self.frame];
}

- (void) loadViews {
    if (self.user) {

    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSLog(@"Init header view!");
    if (self) {
        
        UINib *nib = [UINib nibWithNibName:@"UserStatsView" bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        [self addSubview:self.contentView];
        
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
