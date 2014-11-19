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


- (void)loadUser:(MockUser *) user{
    self.user = user;
    
    self.PFuser = [PFUser currentUser];
    NSLog(@"User: %@", self.PFuser.username);
    
    [Bestie bestiesForUserWithTarget:self.PFuser completion:^(NSArray *besties, NSError *error) {
        self.besties = [[NSMutableArray alloc] initWithArray:besties];
        [self loadViews];
        [self loadStats];
        
    }];
}

- (void)loadStats{
    //name the labels
    self.longestStreakStat.nameLabel.text = @"LONGEST STREAK";
    self.completionStat.nameLabel.text = @"COMPLETION RATE";
    self.bestieCountStat.nameLabel.text = @"BESTIES";
    
    
    //images
    self.longestStreakStat.imageAsset.image = [UIImage imageNamed:@"best_streak"];
    self.longestStreakStat.progressBar.hidden = YES;
    self.longestStreakStat.progressBar2.hidden = YES;
    self.longestStreakStat.backBar.hidden = YES;
    self.completionStat.imageAsset.image = nil;
    self.completionStat.progressBar2.hidden = YES;
    self.bestieCountStat.progressBar.backgroundColor = [UIColor blueColor];

    
    
    //HACK
    self.bestieCountStat.backBar.hidden = YES;
    NSInteger onesDigit = self.besties.count % 10;
    NSLog(@"Ones digit: %ld", onesDigit);
    NSInteger tensDigit = (self.besties.count - onesDigit)/10;
    if (tensDigit < 0) {
        tensDigit = 0;
    }
    NSLog(@"Tens digit: %ld", tensDigit);
    self.bestieCountStat.progressBar2Height.constant = self.bestieCountStat.backBar.frame.size.height * onesDigit/10;
    self.bestieCountStat.progressBarHeight.constant = self.bestieCountStat.backBar.frame.size.height * tensDigit/10;
    
    self.bestieCountStat.imageAsset.image = nil;
    
    //longest streak
    self.longestStreakStat.value.text = [NSString stringWithFormat:@"%ld",[self getLongestStreakOfBesties:self.besties]];
    self.bestieCountStat.value.text = [NSString stringWithFormat:@"%ld", self.besties.count];
    self.completionStat.value.text = [NSString stringWithFormat:@"%2.0f%%", [self completionRate]];
    self.completionStat.progressBarHeight.constant = self.bestieCountStat.backBar.bounds.size.height * [self completionRate]/100;
   
}

- (NSInteger)getLongestStreakOfBesties:(NSArray *)besties{
    NSInteger longestStreak = 1;
    NSInteger currentStreak = 1;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d"];
    Bestie *bestie = besties[0];
    
    NSString *dateForComparison;
    
    // compare it to the day before that
    NSString *dateToCompare = [formatter stringFromDate:[NSDate dateWithTimeInterval:-0 sinceDate:bestie.createDate]];
    for (int i = 0; i < besties.count; i++) {
        bestie = besties[i];
        dateForComparison = bestie.formattedCreateDate;
        //NSLog (@"%d. Comparing date of bestie %@ to date %@", i, dateForComparison, dateToCompare);
        if ([dateForComparison isEqualToString:dateToCompare]) {
            currentStreak++;
        }
        else {
            currentStreak = 1;
        }
        if (currentStreak > longestStreak) {
            longestStreak = currentStreak;
        }
        dateToCompare = [formatter stringFromDate:[NSDate dateWithTimeInterval:-86400 sinceDate:bestie.createDate]];
    }
    NSLog(@"Current streak is %ld", currentStreak);
    return longestStreak;
}

- (float)completionRate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d"];
    NSInteger totalDays;
    NSInteger daysCompleted = 0;
    
    Bestie *mostRecentBestie = [self.besties firstObject];
    NSDate *currentDate = mostRecentBestie.createdAt;
    NSString *dateIterator = [formatter stringFromDate:[NSDate dateWithTimeInterval:-0 sinceDate:currentDate]];
    NSString *dateJoined = [formatter stringFromDate:self.PFuser.createdAt];
    NSMutableDictionary *datesSinceJoined = [[NSMutableDictionary alloc]init];
    while (![dateIterator isEqual:dateJoined]) {
        //NSLog(@"Date: %@", dateIterator);
        //NSLog(@"Date: %@", dateJoined);
        currentDate = [NSDate dateWithTimeInterval:-86400 sinceDate:currentDate];
        dateIterator = [formatter stringFromDate:currentDate];
        [datesSinceJoined setObject:[NSNumber numberWithInteger:0] forKey:dateIterator];
    }
    for (Bestie *b in self.besties) {
        [datesSinceJoined setObject:[NSNumber numberWithInt:1] forKey:b.formattedCreateDate];
    }
    NSArray *values = [datesSinceJoined allValues];
    totalDays = values.count;
    for (int i = 0; i < totalDays; i++) {
        daysCompleted += [values[i] intValue];
    }
    
    //NSLog(@"COMPLETION RATE: %@", datesSinceJoined);
    return (float)100*daysCompleted/totalDays;
    
    
    /*// number of besties divided by number of days since the first post
    
    
    // get the first day the user posted
    Bestie * firstBestie = [self.besties lastObject];
    NSDate * firstDate = firstBestie.createDate;
    
    // get yesterday
    NSDate * yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    
    
    // get number of midnights between them
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSInteger startDay=[gregorian ordinalityOfUnit:NSCalendarUnitDay
                                       inUnit: NSCalendarUnitEra forDate:firstDate];
    NSInteger endDay=[gregorian ordinalityOfUnit:NSCalendarUnitDay
                                     inUnit: NSCalendarUnitEra forDate:yesterday];
    NSInteger difference = endDay-startDay+1;

    float percentage = 100.0f * self.besties.count / difference;*/

    return 0.0;
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
    if (self.PFuser) {
        
        [self.userImageView setImageWithURL: [NSURL URLWithString:@"https://graph.facebook.com/10101363470605773/picture?type=large&return_ssl_resources=1"]];
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
