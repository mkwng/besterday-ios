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
@property (weak, nonatomic) IBOutlet UILabel *bestieDateLabel;

@end

@implementation BestieCell

@synthesize bestie = _bestie;
- (void)setBestie:(Bestie *)bestie {
    // NSLog(@"BestieCell setBestie: %@", bestie);
    _bestie = bestie;
    self.bestieTextLabel.text = bestie.text;
    self.bestieImageView.image = bestie.image;
    self.bestieDateLabel.text = [bestie createFullDate];
    // TODO: fill out image when we have 'em
    // self.bestieImageView =
    
    // make the text not push the date off the top of the screen
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:self.bestieTextLabel
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:self
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:-50];
    [self addConstraint:height];

    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self addGestureRecognizer:tgr];
}

- (void)awakeFromNib {
    // Initialization code
}

@synthesize color = _color;
-(void)setColor:(int)color {
    _color = color;
    
    UIColor *textColor = [UIColor whiteColor];
    switch (color) {
        case BestieCellColorWhite:
            self.backgroundColor = [UIColor colorWithRed:227/255.0f green:223/255.0f blue:223/255.0f alpha:1.0f];
            textColor = [UIColor blackColor];
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
    
    self.bestieTextLabel.textColor = textColor;
    self.bestieDateLabel.textColor = textColor;
}

- (IBAction)onTapGesture:(id)sender {
    NSLog(@"Tapped cell!");

    CGPoint location = [sender locationInView:self.parentVC.view];
    
    ComposeViewController *vc = [[ComposeViewController alloc] init];
    vc.animationStartFrame = self.bestieImageView.frame;
    vc.animationStartCenter = location;//self.bestieImageView.center;
    
    vc.bestie = self.bestie;
    vc.backgroundColor = self.color;
    vc.textColor = self.bestieTextLabel.textColor;
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.parentVC;
    [self.parentVC presentViewController:vc animated:YES completion:nil];
}

@end
