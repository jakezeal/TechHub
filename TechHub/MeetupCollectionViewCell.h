//
//  MeetupCollectionViewCell.h
//  TechHub
//
//  Created by Zeal on 4/7/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetupCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventHost;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;

@end
