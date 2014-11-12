//
//  FeedViewController.m
//  Besterday
//
//  Created by Raylene Yung on 11/12/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "FeedViewController.h"
#import "MenuViewController.h"
#import "BestieCell.h"

@interface FeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *bestieCollectionView;
@property (nonatomic, strong) BestieCell *prototypeCell;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
    [self setupCollectionView];
}

- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(onMenu)];
}

- (void)onMenu {
    [self presentViewController:[[MenuViewController alloc] init] animated:YES completion:nil];
}

- (void)setupCollectionView {
    self.bestieCollectionView.delegate = self;
    self.bestieCollectionView.dataSource = self;
    
    
    UINib *bestieCellNib = [UINib nibWithNibName:@"BestieCell" bundle:nil];
    [self.bestieCollectionView registerNib:bestieCellNib forCellWithReuseIdentifier:@"BestieCell"];
}

#pragma mark UICollectionView methods

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.config = self.bestieConfig[indexPath.row];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BestieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BestieCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
