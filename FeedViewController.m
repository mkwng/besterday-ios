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
#import "Bestie.h"

int const kBestieCellSize = 120;

@interface FeedViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property NSArray *besties;
@property (weak, nonatomic) IBOutlet UICollectionView *bestieCollectionView;
@property (nonatomic, strong) BestieCell *prototypeCell;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupNavigationBar];
    [self setupCollectionView];
    [self loadBesties];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Feed viewWillAppear");
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Feed viewDidAppear");
    [super viewDidAppear:animated];
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

- (void)loadBesties {
    // Create a bunch of past besties for testing!
    // Start from yesterday and go backwards
//    NSDate *startDate = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"EEE, MM/dd";
//    for (int i = 0; i < 10; ++i) {
//        NSDate *curDate = [startDate dateByAddingTimeInterval:-1*60*60*24*i];
//        NSString *text = [NSString stringWithFormat:@"%@: RY - long test string bah", [formatter stringFromDate:curDate]];
//        [Bestie bestie:text date:curDate];
//    }
    
    PFUser *user = [PFUser currentUser];
    [Bestie bestiesForUserWithTarget:user completion:^(NSArray *besties, NSError *error) {
        if (error == nil) {
            self.besties = besties;
            [self.bestieCollectionView reloadData];
            NSLog(@"Feed View: Bestie Feed -- loaded %ld besties", besties.count);
        } else {
            NSLog(@"Error loading besties: %@", error);
        }
    }];
}

#pragma mark UICollectionView methods

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.prototypeCell.config = self.bestieConfig[indexPath.row];
    CGSize size = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1;
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize returnSize = CGSizeMake(kBestieCellSize, kBestieCellSize);
    return returnSize;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.besties.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BestieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BestieCell" forIndexPath:indexPath];
    cell.bestie = self.besties[indexPath.row];
    cell.parentVC = self;//.parentViewController;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

@end
