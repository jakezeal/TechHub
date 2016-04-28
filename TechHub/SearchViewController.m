//
//  ViewController.m
//  TechHub
//
//  Created by Zeal on 4/7/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"
#import "DetailViewController.h"
#import "DataManager.h"
#import "Meetup.h"
#import "NSDate+Utilities.h"

static NSString *cellIdentifier = @"SearchTableViewCell";

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, SearchTableViewCellDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *meetups;
@property (strong, nonatomic) NSMutableArray *filteredData;
@property (strong, nonatomic) UIView *loadingView;
@property BOOL isSearching;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filteredData = [[NSMutableArray alloc] init];
    
    [self prepareSearchBar];
    [self prepareTableView];
    [self prepareMeetups];
}


#pragma mark - Preparation

- (void)prepareSearchBar {
    self.searchBar.delegate = self;
}

- (void)prepareTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)prepareMeetups {
    self.meetups = [[NSMutableArray alloc] init];
    [self startAnimateLoader];
    [[DataManager sharedManager] loadMeetups:^(NSArray *meetups) {
        [self.meetups addObjectsFromArray:meetups];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopAnimateLoader];
            [self.tableView reloadData];
        });
    }];
}

- (void)startAnimateLoader {
    self.loadingView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.loadingView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:253.0/255.0 blue:243.0/255.0 alpha:1]];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setFrame:CGRectMake((self.loadingView.frame.size.width / 2 - 10), (self.loadingView.frame.size.height / 2 - 10), 20, 20)];
    UILabel *patience = [[UILabel alloc] initWithFrame:CGRectMake((self.loadingView.frame.size.width / 2 - 100), (self.loadingView.frame.size.height / 4), 200, 30)];
    patience.text = @"Please be patient, friend.";
    UILabel *loading = [[UILabel alloc] initWithFrame:CGRectMake((self.loadingView.frame.size.width / 2 - 30), (self.loadingView.frame.size.height / 2 + 20), 100, 30)];
    loading.text = @"Loading";
    [self.loadingView addSubview:activityIndicator];
    [self.loadingView addSubview:patience];
    [self.loadingView addSubview:loading];
    [activityIndicator startAnimating];
    [self.view addSubview:self.loadingView];
}

- (void)stopAnimateLoader {
    [self.loadingView removeFromSuperview];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        return self.filteredData.count;
    } else {
        return self.meetups.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:cell indexPath:indexPath];
    return cell;
}

- (void)configureCell:(SearchTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    Meetup *meetup = nil;
    if (self.isSearching) {
        meetup = self.filteredData[indexPath.row];
    } else {
        meetup = [self.meetups objectAtIndex:indexPath.row];
    }
    
    NSTimeInterval seconds = [meetup.eventTime doubleValue] / 1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];

    cell.eventName.text = meetup.eventName;
    cell.eventHost.text = meetup.eventHost;
    cell.eventLocation.text = meetup.eventLocation;
    cell.eventTime.text = [date mediumString];
    cell.indexPath = indexPath;
    
    if ([self isInFavourites:meetup]) {
        cell.favouriteButton.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:163.0/255.0  blue:204.0/255.0  alpha:1];
        [cell.favouriteButton setTitle:@"In favourites" forState:UIControlStateNormal];
        meetup.isFavorite = YES;
    } else {
        cell.favouriteButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:27.0/255.0  blue:59.0/255.0  alpha:1];
        [cell.favouriteButton setTitle:@"Favourite" forState:UIControlStateNormal];
        meetup.isFavorite = NO;
    }
    
    
}

#pragma mark - UITableViewDelgate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Meetup *meetup = nil;
    if (self.isSearching) {
        meetup = self.filteredData[indexPath.row];
    } else {
        meetup = [self.meetups objectAtIndex:indexPath.row];
    }
    DetailViewController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
    dvc.meetup = meetup;
    [self.navigationController pushViewController:dvc animated:true];
}

#pragma mark - SearchTableViewDelegate

- (void)favouriteButtonPressed:(SearchTableViewCell *)cell {
    Meetup *meetup = nil;
    if (self.isSearching) {
        meetup = self.filteredData[cell.indexPath.row];
    } else {
        meetup = [self.meetups objectAtIndex:cell.indexPath.row];
    }
    
    if ([self isInFavourites:meetup]) {
        cell.favouriteButton.backgroundColor = [UIColor colorWithRed:255 green:27 blue:59 alpha:1];
        [cell.favouriteButton setTitle:@"Add to Favourites" forState:UIControlStateNormal];
        [[[DataManager sharedManager] favourites] removeObject:meetup];
    } else {
        cell.favouriteButton.backgroundColor = [UIColor colorWithRed:76.0/255.0 green:163.0/255.0  blue:204.0/255.0  alpha:1];
        [cell.favouriteButton setTitle:@"In favourites" forState:UIControlStateNormal];
        [[[DataManager sharedManager] favourites] addObject:meetup];
    }
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.filteredData removeAllObjects];
    for (Meetup *meetup in self.meetups) {
        if ([meetup.eventName containsString:searchText]) {
            [self.filteredData addObject: meetup];
        }
    }
    self.isSearching = searchText.length == 0 ? false : true;
    [self.tableView reloadData];
}

#pragma mark - Helpers

- (BOOL)isInFavourites:(Meetup *)meetup {
    for (Meetup *favourite in [[DataManager sharedManager] favourites]) {
        if ([favourite.identifier isEqualToString:meetup.identifier]) {
            return YES;
        }
    }
    return NO;
}
@end
