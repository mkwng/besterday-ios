//
//  ComposeViewController.h
//  Besterday
//
//  Created by Wes Chao on 11/10/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bestie.h"
#import "BestieCell.h"

@interface ComposeViewController : UIViewController
@property Bestie * bestie;
@property (nonatomic)BestieCellColor backgroundColor;
@property UIColor* textColor;

@end
