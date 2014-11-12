//
//  MenuViewController.m
//  Besterday
//
//  Created by Raylene Yung on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"
#import "ComposeViewController.h"

int const kProfileItemIndex = 0;
int const kTodayItemIndex = 1;
int const kCalendarItemIndex = 2;
int const kComposeItemIndex = 3;

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *menuItemConfig;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) MenuItemCell *prototypeCell;

@end

@implementation MenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupMenuTable];
}

- (void)setupMenuTable {
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    self.menuTableView.rowHeight = UITableViewAutomaticDimension;
    // No footer
    self.menuTableView.tableFooterView = [[UIView alloc] init];
    
    UINib *menuItemCellNib = [UINib nibWithNibName:@"MenuItemCell" bundle:nil];
    [self.menuTableView registerNib:menuItemCellNib forCellReuseIdentifier:@"MenuItemCell"];
    
    // Init menu item option configurations
    self.menuItemConfig =
    @[
      @{@"name" : @"Profile", @"img":@"home"},
      @{@"name" : @"Today", @"img": @"home"},
      @{@"name" : @"Calendar", @"img": @"home"},
      @{@"name" : @"Compose", @"img": @"home"},
      ];
}

#pragma mark - Custom setters

- (MenuItemCell *)prototypeCell {
    if (_prototypeCell == nil) {
        _prototypeCell = [self.menuTableView dequeueReusableCellWithIdentifier:@"MenuItemCell"];
    }
    return _prototypeCell;
}

#pragma mark - UITableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.config = self.menuItemConfig[indexPath.row];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell" forIndexPath:indexPath];
    cell.config = self.menuItemConfig[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItemConfig.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc;
    // TODO: add the rest of these
    if (indexPath.row == kProfileItemIndex) {
        return;
    } else if (indexPath.row == kTodayItemIndex) {
        return;
    } else if (indexPath.row == kCalendarItemIndex) {
        return;
    } else if (indexPath.row == kComposeItemIndex) {
        vc = [[ComposeViewController alloc] init];
    }
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

@end
