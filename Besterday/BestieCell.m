//
//  BestieCell.m
//  Besterday
//
//  Created by Raylene Yung on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "BestieCell.h"
#import "ComposeViewController.h"

@interface BestieCell()

@property (weak, nonatomic) IBOutlet UIImageView *bestieImageView;
@property (weak, nonatomic) IBOutlet UILabel *bestieTextLabel;

@end

@implementation BestieCell

@synthesize bestie = _bestie;
- (void)setBestie:(Bestie *)bestie {
    // NSLog(@"BestieCell setBestie: %@", bestie);
    _bestie = bestie;
    self.bestieTextLabel.text = bestie.text;
    // TODO: fill out image when we have 'em
    // self.bestieImageView =
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self addGestureRecognizer:tgr];
}

- (void)awakeFromNib {
    // Initialization code
}

-(void) setColor:(BestieCellColor)color {
    self.bestieTextLabel.textColor = [UIColor whiteColor];
    switch (color) {
        case BestieCellColorWhite:
            self.backgroundColor = [UIColor colorWithRed:227/255.0f green:223/255.0f blue:223/255.0f alpha:1.0f];
            self.bestieTextLabel.textColor = [UIColor blackColor];
            break;
        case BestieCellColorBlack:
            self.backgroundColor = [UIColor colorWithRed:66/255.0f green:61/255.0f blue:63/255.0f alpha:1.0f];
            break;
        case BestieCellColorGreen:
            self.backgroundColor = [UIColor colorWithRed:107/255.0f green:186/255.0f blue:159/255.0f alpha:1.0f];
            break;
        case BestieCellColorOrange:
            self.backgroundColor = [UIColor colorWithRed:228/255.0f green:137/255.0f blue:87/255.0f alpha:1.0f];
            break;
    }
}

- (IBAction)onTapGesture:(id)sender {
    NSLog(@"Tapped cell!");

    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.bestie = self.bestie;
    vc.backgroundColor = self.backgroundColor;
    vc.textColor = self.bestieTextLabel.textColor;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.parentVC presentViewController:nvc animated:YES completion:nil];
}
@end
