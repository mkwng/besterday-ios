//
//  BestieCell.m
//  Besterday
//
//  Created by Raylene Yung on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "BestieCell.h"

@interface BestieCell()

@property (weak, nonatomic) IBOutlet UIImageView *bestieImageView;
@property (weak, nonatomic) IBOutlet UILabel *bestieTextLabel;

@end

@implementation BestieCell

@synthesize bestie = _bestie;
- (void)setBestie:(Bestie *)bestie {
    NSLog(@"BestieCell setBestie: %@", bestie);
    _bestie = bestie;
    self.bestieTextLabel.text = bestie.text;
    // TODO: fill out image when we have 'em
    // self.bestieImageView =
}
- (void)awakeFromNib {
    // Initialization code
}

@end
