//
//  UserHeaderView.m
//  
//
//  Created by Larry Wei on 11/12/14.
//
//

#import "UserHeaderView.h"
#import "Bestie.h"
#import <Parse/Parse.h>
#import "UserStatsView.h"
#import "UIImageView+AfNetworking.h"

@interface UserHeaderView()


@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTagline;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) MockUser *user;
@property (nonatomic, strong) PFUser *PFuser;

@property (nonatomic, strong) NSMutableArray *besties;




@end

@implementation UserHeaderView

- (void)loadUser:(MockUser *) user{
    self.user = user;
    
    self.PFuser = [PFUser currentUser];
    NSLog(@"User: %@", self.PFuser.username);
    
    [Bestie bestiesForUserWithTarget:self.PFuser completion:^(NSArray *besties, NSError *error) {
        self.besties = [[NSMutableArray alloc] initWithArray:besties];
//        NSLog(@"Besties have been loaded");
//        NSInteger count = 0;
//        for (Bestie *b in self.besties) {
//            NSLog(@"Bestie text %ld: %@", ++count, b.text);
//        }
        [self setUpStats];
        [self loadViews];
    }];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setFrame:self.frame];
}


- (void) addStat:(UIView *)view container:(UIView*)container{
    [container addSubview:view];
    [self.statsContainerView setNeedsLayout];
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}


- (void)setUpStats {
/*    UserStatsView *stat1 = [[UserStatsView alloc] initWithFrame:self.stat1.bounds];
    stat1.value.text = @"42%";
    UserStatsView *stat2 = [[UserStatsView alloc] initWithFrame:self.stat2.bounds];
    stat2.value.text = [NSString stringWithFormat:@"%ld", self.besties.count];
    UserStatsView *stat3 = [[UserStatsView alloc] initWithFrame:self.stat3.bounds];
    stat3.value.text = [NSString stringWithFormat:@"%ld", self.besties.count-1];
    [self addStat: stat1 container:self.stat1];
    [self addStat: stat2 container:self.stat2];
    [self addStat: stat3 container:self.stat3];*/

}

- (void) loadViews {
    if (self.user) {
        
        [self.userImageView setImageWithURL: [NSURL URLWithString:(self.PFuser[@"profileImageUrl"])]];
        self.userNameLabel.text = self.PFuser.username;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMMM d"];
        NSString* tagline = [NSString stringWithFormat:@"Besties since %@", [formatter stringFromDate:self.PFuser.createdAt]];


        self.userTagline.text = tagline;
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
        self.userImageView.clipsToBounds = YES;
        [self.userImageView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.userImageView.layer setBorderWidth: 0.5];
        
    }
}

- (void)setup {
    UINib *nib = [UINib nibWithNibName:@"UserHeaderView" bundle:nil];
    [nib instantiateWithOwner:self options:nil];
    [self addSubview:self.contentView];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSLog(@"Init header view!");
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
