//
//  DataManager.h
//  TechHub
//
//  Created by Zeal on 4/4/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Meetup;

@interface DataManager : NSObject

@property (strong, nonatomic) NSMutableArray <Meetup *> *favourites;

- (void)loadMeetups:(void(^)(NSArray *meetups))completion;

+ (id)sharedManager;

@end