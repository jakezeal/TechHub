//
//  DataManager.h
//  TechHub
//
//  Created by Zeal on 4/4/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class TransientMeetup;
@class Meetup;

@protocol DataManagerDelegate <NSObject>

- (void)didUpdateData;

@end

@interface DataManager : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableArray *meetups;
@property (nonatomic, strong) NSMutableArray <Meetup *> *favoriteMeetups;
@property (nonatomic, weak) id <DataManagerDelegate> delegate;
@property (nonatomic, strong, readonly) NSDictionary <NSString *, Meetup*> *dictionary;
- (void)createQueryString:(CLLocationCoordinate2D)coordinate;
- (void)fetchFavorites;

@end
