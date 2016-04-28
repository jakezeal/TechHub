//
//  DataManager.m
//  TechHub
//
//  Created by Zeal on 4/4/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import "DataManager.h"
#import "Meetup.h"

@implementation DataManager

- (instancetype)init {
    self = [super init];
    if (self) {
        self.favourites = [[NSMutableArray alloc] init]; 
    }
    return self;
}

+ (id)sharedManager {
    static DataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSURL *)queryString { // Coordinate should be passed in the future.
    NSString *baseURL = @"https://api.meetup.com/2/open_events";
    NSURLComponents *components = [NSURLComponents componentsWithString:baseURL];
    NSURLQueryItem *queryAPI = [NSURLQueryItem queryItemWithName:@"key" value:@"345431657b2d20632d47254d28455224"];
    NSURLQueryItem *querySign = [NSURLQueryItem queryItemWithName:@"sign" value:@"true"];
    NSURLQueryItem *queryCategory = [NSURLQueryItem queryItemWithName:@"category" value:@"34"];
    NSURLQueryItem *queryLat = [NSURLQueryItem queryItemWithName:@"lat" value:[@(40.759211) stringValue]]; // Needs to be dynamic location
    NSURLQueryItem *queryLon = [NSURLQueryItem queryItemWithName:@"lon" value:[@(-73.984638) stringValue]];
    NSURLQueryItem *queryPage = [NSURLQueryItem queryItemWithName:@"page" value:@"40"];
    [components setQueryItems:@[queryAPI, querySign, queryCategory, queryLat, queryLon, queryPage]];
    return components.URL;
}

- (void)loadMeetups:(void(^)(NSArray *meetups))completion {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[self queryString]];
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
                NSMutableArray *arrayOfTitles = [[NSMutableArray alloc]init];
                
                for (NSDictionary *meetupDict in meetupArray) {
                    
                    if ([meetupArray containsObject:arrayOfTitles.lastObject]) {
                        continue;
                    }
                    Meetup *meetup = [[Meetup alloc]init];
                    meetup.identifier = meetupDict[@"id"];
                    meetup.eventName = meetupDict[@"name"];
                    [arrayOfTitles addObject:meetup.eventName];
                    meetup.eventLocation = meetupDict[@"venue"][@"address_1"];
                    meetup.city = meetupDict[@"venue"][@"city"];
                    meetup.eventDescription = meetupDict[@"description"];
                    meetup.eventTime = meetupDict[@"time"];
                    meetup.eventHost = meetupDict[@"group"][@"name"];
                    meetup.eventURL = meetupDict[@"event_url"];
                    [objects addObject:meetup];
                }
                completion(objects);
            }
        } else {
            NSLog(@"There was an error: %@ \n", error.localizedDescription);
        }
    }];
    [dataTask resume];
}

@end
