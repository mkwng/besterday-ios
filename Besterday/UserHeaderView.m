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
        //NSLog(@"Besties have been loaded");
        NSInteger count = 0;
        for (Bestie *b in self.besties) {
            NSLog(@"Bestie text %ld: %@", ++count, b.text);
        }
    }];
    
    [self loadViews];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setFrame:self.frame];
}

- (void) loadViews {
    if (self.user) {
        self.userImageView.image = self.user.getPicture;
        self.userNameLabel.text = self.PFuser.username;
        self.userTagline.text = self.user.getTagline;
        self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
        self.userImageView.clipsToBounds = YES;
        [self.userImageView.layer setBorderColor: [[UIColor orangeColor] CGColor]];
        [self.userImageView.layer setBorderWidth: 0.6];
        
        
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    NSLog(@"Init header view!");
    if (self) {
        
        UINib *nib = [UINib nibWithNibName:@"UserHeaderView" bundle:nil];
        [nib instantiateWithOwner:self options:nil];
        [self addSubview:self.contentView];
        
    }
    
    return self;
}


/*- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
