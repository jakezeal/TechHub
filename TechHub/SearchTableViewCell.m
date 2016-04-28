//
//  SearchTableViewCell.m
//  TechHub
//
//  Created by Zeal on 4/7/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.favouriteButton addTarget:self action:@selector(favouritePressed) forControlEvents:UIControlEventTouchUpInside];
}

- (void)favouritePressed {
    [self.delegate favouriteButtonPressed:self];
}

@end
