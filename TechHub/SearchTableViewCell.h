//
//  SearchTableViewCell.h
//  TechHub
//
//  Created by Zeal on 4/7/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchTableViewCell;

@protocol SearchTableViewCellDelegate <NSObject>

- (void)favouriteButtonPressed:(SearchTableViewCell *)cell;

@end

@interface SearchTableViewCell : UITableViewCell

@property (weak, nonatomic) id <SearchTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventHost;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UIButton *favouriteButton;
@property (strong, nonatomic) NSIndexPath *indexPath; 

@end
