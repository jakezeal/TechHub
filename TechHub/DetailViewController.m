//
//  DetailViewController.m
//  TechHub
//
//  Created by Zeal on 4/7/16.
//  Copyright © 2016 Jake Zeal. All rights reserved.
//

#import "DetailViewController.h"
#import "DataManager.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventHost;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.eventName.text = self.meetup.eventName;
//    self.eventHost.text = self.meetup.eventHost;
//    self.eventDescription.text = self.meetup.eventDescription;
//    self.eventLocation.text = self.meetup.eventLocation;
//    self.eventTime.text = [self.meetup.eventTime stringValue];
    [self prepareWebView];
}

#pragma mark - Preperations

- (void)prepareWebView {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.meetup.eventURL]];
    [self.webView loadRequest:request];
}

@end
