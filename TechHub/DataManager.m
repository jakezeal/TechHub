//
//  DataManager.m
//  TechHub
//
//  Created by Zeal on 4/4/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import "DataManager.h"
#import "LocationManager.h"
#import "Meetup.h"
#import "AppDelegate.h"
#import "TransientMeetup.h"

@interface DataManager () <DataManagerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation DataManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        AppDelegate *del = (AppDelegate *) [UIApplication sharedApplication].delegate;
        self.managedObjectContext = del.managedObjectContext;
        
    }
    return self;
}

- (void)createQueryString:(CLLocationCoordinate2D)coordinate {
    NSString *baseURL = @"https://api.meetup.com/2/open_events";
    NSURLComponents *components = [NSURLComponents componentsWithString:baseURL];
    NSURLQueryItem *queryAPI = [NSURLQueryItem queryItemWithName:@"key" value:@"345431657b2d20632d47254d28455224"];
    NSURLQueryItem *querysign = [NSURLQueryItem queryItemWithName:@"sign" value:@"true"];
    NSURLQueryItem *querycategory = [NSURLQueryItem queryItemWithName:@"category" value:@"34"];
    NSURLQueryItem *queryLat = [NSURLQueryItem queryItemWithName:@"lat" value:[@(coordinate.latitude) stringValue]];
    NSURLQueryItem *queryLon = [NSURLQueryItem queryItemWithName:@"lon" value:[@(coordinate.longitude) stringValue]];
    [components setQueryItems:@[queryAPI, querysign, querycategory, queryLat, queryLon]];
    self.url = components.URL;
    [self fetchData];
}

- (void)fetchData {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error) {
            NSError *jsonError;
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:0
                                                                         error:&jsonError];
            if (!jsonError) {
                NSMutableArray *objects = [[NSMutableArray alloc]init];
                NSArray *meetupArray = jsonObject[@"results"];
                
                for (NSDictionary *meetupDict in meetupArray) {
                    //Save to array in normal NSObject
                    TransientMeetup *meetup = [[TransientMeetup alloc]init];
                    
                    meetup.identifier = meetupDict[@"id"];
                    meetup.eventName = meetupDict[@"venue"][@"name"];
                    meetup.location = meetupDict[@"venue"][@"address_1"];
                    meetup.city = meetupDict[@"venue"][@"city"];
                    meetup.meetupDescription = meetupDict[@"description"];
                    meetup.yesRsvpCount = meetupDict[@"yes_rsvp_count"];
                    meetup.time = meetupDict[@"time"];
                    meetup.duration = meetupDict[@"duration"];
                    meetup.groupName = meetupDict[@"group"][@"name"];
                    [objects addObject:meetup];
                }
                self.meetups = objects;
                
                [self.delegate didUpdateData];
            }
        } else {
            NSLog(@"There was an error: %@ \n", error.localizedDescription);
        }
    }];
    [dataTask resume];
}

- (void)fetchFavorites {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meetup" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@", error.localizedDescription);
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (Meetup *meetup in fetchedObjects) {
        dict[meetup.identifier] = meetup;
    }
    _dictionary = dict;
}

@end
