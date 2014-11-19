//
//  BestieCell.h
//  Besterday
//
//  Created by Raylene Yung on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bestie.h"
#import "UserProfileViewController.h"

@interface BestieCell : UICollectionViewCell

@property (nonatomic, strong) Bestie *bestie;

// this should be a BestieCellColor, but the compiler doesn't like that
@property (nonatomic, assign) int color;

// NOTE: is this set magically already somewhere?
@property (nonatomic, strong) UserProfileViewController *parentVC;

typedef enum BestieCellColor : NSUInteger {
    BestieCellColorGreen,
    BestieCellColorOrange,
    BestieCellColorBlack,
    BestieCellColorWhite,
} BestieCellColor;

-(void) setColor:(int)color;
@end
