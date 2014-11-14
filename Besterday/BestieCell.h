//
//  BestieCell.h
//  Besterday
//
//  Created by Raylene Yung on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bestie.h"

@interface BestieCell : UICollectionViewCell

@property (nonatomic, strong) Bestie *bestie;

// NOTE: is this set magically already somewhere?
@property (nonatomic, strong) UIViewController *parentVC;
@end
