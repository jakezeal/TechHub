//
//  MeetupViewController.m
//  TechHub
//
//  Created by Zeal on 4/7/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import "MeetupViewController.h"
#import "DataManager.h"
#import "Meetup.h"
#import "MeetupCollectionViewCell.h"
#import "NSDate+Utilities.h"
#import "DetailViewController.h"

@interface MeetupViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *noEvent;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *techHubLabel;
@property (weak, nonatomic) IBOutlet UILabel *techHubTagLine;

@end

@implementation MeetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareCollectionView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
//    [UIColor colorWithRed:255.0/255.0 green:27.0/255.0  blue:59.0/255.0  alpha:1];
//    self.navigationController = [UIColor colorWithRed:76.0/255.0 green:163.0/255.0  blue:204.0/255.0  alpha:1];
    [self.collectionView reloadData];
    if ([[DataManager sharedManager] favourites].count == 0) {
        self.collectionView.hidden = YES;
        self.techHubLabel.hidden = NO;
        self.techHubTagLine.hidden = NO;
    } else {
        self.collectionView.hidden = NO;
        self.techHubLabel.hidden = YES;
        self.techHubTagLine.hidden = YES;
    }
}

#pragma mark - Preperations

- (void)prepareCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((self.view.frame.size.width) - 10, (self.view.frame.size.width / 2) - 10);
    layout.minimumLineSpacing = 20;
   // layout.minimumInteritemSpacing = 10;
//    layout.sectionInset = UIEdgeInsetsMake(0, 8, 0, 8);
    self.collectionView.collectionViewLayout = layout;
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[DataManager sharedManager] favourites].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    MeetupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Meetup *meetup = [[DataManager sharedManager] favourites][indexPath.row];
    
    
    NSTimeInterval seconds = [meetup.eventTime doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    cell.eventName.text = meetup.eventName;
    cell.eventHost.text = meetup.eventHost;
    cell.eventLocation.text = meetup.eventLocation;
    cell.eventTime.text = [date mediumString];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Meetup *meetup = [[DataManager sharedManager]favourites][indexPath.row];
    DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    dvc.meetup = meetup;
    [self.navigationController pushViewController:dvc animated:true];
}


// Push View Controller
//
//
//Meetup *meetup = [[[DataManager sharedManager] favourites] objectAtIndex:indexPath.row];
//}
//DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
//dvc.meetup = meetup;
//[self.navigationController pushViewController:dvc animated:true];


@end
