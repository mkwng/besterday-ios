//
//  MenuItemCell.m
//  Besterday
//
//  Created by Raylene Yung on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "MenuItemCell.h"

@interface MenuItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;

@end

@implementation MenuItemCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setConfig:(NSDictionary *)config {
    _config = config;
    self.itemName.text = config[@"name"];
    self.itemImage.image = [UIImage imageNamed:config[@"img"]];
}

@end
