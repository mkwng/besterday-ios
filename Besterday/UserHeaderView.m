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
@property (nonatomic, assign) NSInteger longestStreak;
@property (weak, nonatomic) IBOutlet UserStatsView *completionStat;
@property (weak, nonatomic) IBOutlet UserStatsView *bestieCountStat;
@property (weak, nonatomic) IBOutlet UserStatsView *longestStreakStat;



@end

@implementation UserHeaderView

- (NSInteger)getCompletionPercentage {
    NSInteger currentStreak = 0;
//    NSLocale* currentLocale = [NSLocale currentLocale];
    //NSDate *dateToday = [[NSDate date] descriptionWithLocale:currentLocale];
    //NSDate time
    return currentStreak;
}

- (void)loadUser:(MockUser *) user{
    self.user = user;
    
    self.PFuser = [PFUser currentUser];
    NSLog(@"User: %@", self.PFuser.username);
    
    [Bestie bestiesForUserWithTarget:self.PFuser completion:^(NSArray *besties, NSError *error) {
        self.besties = [[NSMutableArray alloc] initWithArray:besties];
        
        [self loadStats];
        [self loadViews];
    }];
}

- (void)loadStats{
    //name the labels
    self.longestStreakStat.nameLabel.text = @"LONGEST STREAK";
    self.completionStat.nameLabel.text = @"COMPLETION RATE";
    self.bestieCountStat.nameLabel.text = @"BESTIES";
    
    //images
    self.longestStreakStat.imageAsset.image = [UIImage imageNamed:@"ribbon"];
    self.completionStat.imageAsset.image = [UIImage imageNamed:@"stats"];
    self.bestieCountStat.imageAsset.image = [UIImage imageNamed:@"star"];
    
    //longest streak
    self.longestStreakStat.value.text = [NSString stringWithFormat:@"%ld",[self getLongestStreakOfBesties:self.besties]];
    self.bestieCountStat.value.text = [NSString stringWithFormat:@"%ld", self.besties.count];
}

- (NSInteger)getLongestStreakOfBesties:(NSArray *)besties{
    NSInteger longestStreak = 1;
    NSInteger currentStreak = 1;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d"];
    Bestie *bestie = besties[0];
    
    NSString *dateForComparison;
    
    // compare it to the day before that
    NSString *dateToCompare = [formatter stringFromDate:[NSDate dateWithTimeInterval:-86400 sinceDate:bestie.createDate]];
    for (int i = 1; i < besties.count; i++) {
        bestie = besties[i];
        dateForComparison = bestie.formattedCreateDate;
//        NSLog (@"Comparing date %@ to date %@", dateForComparison, dateToCompare);
        if ([dateForComparison isEqualToString:dateToCompare]) {
            currentStreak++;
        }
        else
            currentStreak = 0;
        
        if (currentStreak > longestStreak) {
            longestStreak = currentStreak;
        }
        dateToCompare = [formatter stringFromDate:[NSDate dateWithTimeInterval:-86400 sinceDate:bestie.createDate]];
    }
    NSLog(@"Current streak is %ld", currentStreak);
    return longestStreak;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setFrame:self.frame];
}


- (void) addStat:(UIView *)view container:(UIView*)container{
    [container addSubview:view];
    [self.statsContainerView setNeedsLayout];
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
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
