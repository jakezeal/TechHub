//
//  Meetup.h
//  TechHub
//
//  Created by Zeal on 4/7/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meetup : NSObject

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSNumber *distance;

// Core information
@property (nullable, nonatomic, retain) NSString *eventName;
@property (nullable, nonatomic, retain) NSString *eventHost;
@property (nullable, nonatomic, retain) NSString *eventLocation;
@property (nullable, nonatomic, retain) NSString *eventDescription;
@property (nullable, nonatomic, retain) NSNumber *eventTime;
@property (nullable, nonatomic) NSString *eventURL;

@property (nullable, nonatomic, retain) NSString *identifier;
@property (assign, nonatomic) BOOL isFavorite;


@end
